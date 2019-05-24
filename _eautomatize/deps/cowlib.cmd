@echo * Compiling COWLIB
@set dep_cowlib=priv/cowlib
@FOR /R "%dep_cowlib%/src" %%j in (*.erl) DO @(
  erlc -v -pa %dep_cowlib%/ebin/ -Werror +debug_info -I %dep_cowlib%/include/ -W -o %dep_cowlib%/ebin/ "%%j"
)