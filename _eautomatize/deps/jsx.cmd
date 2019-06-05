@echo * Compiling JSX
@set dep_jsx=priv/jsx
@FOR /R "%dep_jsx%/src" %%j in (*.erl) DO @(
  erlc -v -pa %dep_jsx%/ebin/ -Werror +debug_info -W -o %dep_jsx%/ebin/ "%%j"
)
