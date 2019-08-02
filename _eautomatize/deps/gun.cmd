@call _eautomatize/deps/cowlib.cmd

@echo * Compiling GUN
@set dep_gun=deps/gun
@FOR /R "%dep_gun%/src" %%j in (*.erl) DO @(
  erlc -v -pa %dep_gun%/ebin/ -pa %dep_cowlib%/ebin -Werror +debug_info -W -o %dep_gun%/ebin/ "%%j"
)
