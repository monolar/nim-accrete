import macros

macro class*(head: expr, body: stmt): stmt {.immediate.} =
  # The macro is immediate so that it doesn't
  # resolve identifiers passed to it

  var typeName, baseName: PNimrodNode

  #echo head.kind
  #echo repr(head)

  if head.kind == nnkIdent:
    # `head` is expression `typeName`
    #echo "head => \n" & $head.treeRepr
    # --------------------
    # Ident !"Animal"
    typeName = head

  elif head.kind == nnkInfix and $head[0] == "of":
    # `head` is expression `typeName of baseClass`
    # echo head.treeRepr
    # --------------------
    # Infix
    #   Ident !"of"
    #   Ident !"Animal"
    #   Ident !"TObject"
    typeName = head[1]
    baseName = head[2]

  else:
    quit "Invalide node: " & head.lispRepr

  #echo treeRepr(body)
  # --------------------
  # StmtList
  #   VarSection
  #     IdentDefs
  #       Ident !"name"
  #       Ident !"string"
  #       Empty
  #     IdentDefs
  #       Ident !"age"
  #       Ident !"int"
  #       Empty
  #   MethodDef
  #     Ident !"vocalize"
  #     Empty
  #     Empty
  #     FormalParams
  #       Ident !"string"
  #     Empty
  #     Empty
  #     StmtList
  #       StrLit ...
  #   MethodDef
  #     Ident !"age_human_yrs"
  #     Empty
  #     Empty
  #     FormalParams
  #       Ident !"int"
  #     Empty
  #     Empty
  #     StmtList
  #       DotExpr
  #         Ident !"this"
  #         Ident !"age"

  # create a new stmtList for the result
  result = newStmtList()

  # var declarations will be turned into object fields
  var recList = newNimNode(nnkRecList)

  # Iterate over the statements, adding `this: T`
  # to the parameters of functions
  for node in body.children:
    case node.kind:

      of nnkMethodDef, nnkProcDef:
        # inject `this: T` into the arguments
        let p = copyNimTree(node.params)
        p.insert(1, newIdentDefs(ident"this", typeName))
        node.params = p
        result.add(node)

      of nnkVarSection:
        # variables get turned into fields of the type.
        for n in node.children:
          recList.add(n)

      else:
        result.add(node)

  # The following prints out the AST structure:
  #
  # import macros
  # dumptree:
  #   type X = ref object of Y
  #     z: int
  # --------------------
  # TypeSection
  #   TypeDef
  #     Ident !"X"
  #     Empty
  #     RefTy
  #       ObjectTy
  #         Empty
  #         OfInherit
  #           Ident !"Y"
  #         RecList
  #           IdentDefs
  #             Ident !"z"
  #             Ident !"int"
  #             Empty

  result.insert(0,
    if baseName == nil:
      quote do:
        type `typeName` = ref object
    else:
      quote do:
        type `typeName` = ref object of `baseName`
  )
  # Inspect the tree structure:
  #
  # echo result.treeRepr
  # --------------------
  # StmtList
  #   StmtList
  #     TypeSection
  #       TypeDef
  #         Ident !"Animal"
  #         Empty
  #         RefTy
  #           ObjectTy
  #             Empty
  #             OfInherit
  #               Ident !"TObject"
  #             Empty   <= We want to replace this
  #   MethodDef
  #   ...

  result[0][0][0][2][0][2] = recList

  # Lets inspect the human-readable version of the output
  #echo "-------"
  #echo repr(result)
  #echo "-------"

  # Output:
  #  type
  #    Animal = ref object of TObject
  #      name: string
  #      age: int
  #
  #  method vocalize(this: Animal): string =
  #    "..."
  #
  #  method age_human_yrs(this: Animal): int =
  #    this.age

