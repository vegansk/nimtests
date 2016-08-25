import compiler.nimeval

let prg = """
echo "Hello, world!"
"""

nimeval.execute(prg)
