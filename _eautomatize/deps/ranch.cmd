@echo * Compiling RANCH
@set dep_ranch=priv/ranch
@FOR /R "%dep_ranch%/src" %%j in (*.erl) DO @(
  erlc -v -pa %dep_ranch%/ebin/ -Werror +debug_info -I %dep_ranch%/include/ -W -o %dep_ranch%/ebin/ "%%j"
)