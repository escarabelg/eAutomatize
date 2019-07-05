@echo * Compiling EFIREBIRDSQL
@set dep_efirebirdsql=priv/efirebirdsql
@FOR /R "%dep_efirebirdsql%/src" %%j in (*.erl) DO @(
  erlc -v -pa %dep_efirebirdsql%/ebin/ -Werror +debug_info -I %dep_efirebirdsql%/include/ -W -o %dep_efirebirdsql%/ebin/ "%%j"
)
