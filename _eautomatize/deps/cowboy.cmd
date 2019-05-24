@call _eautomatize/deps/ranch.cmd
@call _eautomatize/deps/cowlib.cmd

@echo * Compiling COWBOY
@set dep_cowboy=priv/cowboy
@FOR /R "%dep_cowboy%/src" %%j in (*.erl) DO @(
  erlc -v -pa %dep_cowboy%/ebin/ -pa %dep_ranch%/ebin -pa %dep_cowlib%/ebin -Werror +debug_info -I %dep_cowboy%/include/ -W -o %dep_cowboy%/ebin/ "%%j"
)