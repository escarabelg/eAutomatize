:: ----------------------------------------------------------
::        ___        _                        _   _         
::       / _ \      | |                      | | (_)        
::   ___/ /_\ \_   _| |_ ___  _ __ ___   __ _| |_ _ _______ 
::  / _ \  _  | | | | __/ _ \| '_ ` _ \ / _` | __| |_  / _ \
:: |  __/ | | | |_| | || (_) | | | | | | (_| | |_| |/ /  __/
::  \___\_| |_/\__,_|\__\___/|_| |_| |_|\__,_|\__|_/___\___|
::                                                                                                               
:: This batch file helper erlang developer
::
:: @author: Guilherme Escarabel - guilherme@escarabel.com
:: @version: 1.0.0
:: ----------------------------------------------------------


:: get name of current folder and use for name of project app
@for %%I in (.) do @set app_name=%%~nxI


:: Commands availables
@if "%1"=="compile" @goto compile
@if "%1"=="release" @goto release
@if "%1"=="compile_dep" @goto compile_dep
@if "%1"=="relup" @goto relup
@if "%1"=="tar" @goto tar
@if "%1"=="doc" @goto doc
@if "%1"=="gen_structure" @goto gen_structure
@if "%1"=="help" @goto help


:: Tasks availables
@if "%1"=="--release" @goto task_release
@if "%1"=="--relup" @goto task_relup


:: Help
:help
@echo "'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"  
@echo "'       / _ \      | |                      | | (_)         '"
@echo "'   ___/ /_\ \_   _| |_ ___  _ __ ___   __ _| |_ _ _______  '"
@echo "'  / _ \  _  | | | | __/ _ \| '_ ` _ \ / _` | __| |_  / _ \ '"
@echo "' |  __/ | | | |_| | || (_) | | | | | | (_| | |_| |/ /  __/ '"
@echo "'  \___\_| |_/\__,_|\__\___/|_| |_| |_|\__,_|\__|_/___\___| '"
@echo "'                                                           '"
@echo "' Commands availables:                                      '"
@echo "'   compile - compile project (src to ebin)                 '"
@echo "'   release - create new release                            '"
@echo "'   relup - generate a upgrade release                      '"
@echo "'   compile_dep - compile dep informed                      '"
@echo "'   tar - compact current release                           '"
@echo "'   doc - generate doc for this project                     '"
@echo "'   gen_structure - generate structure of project app       '"
@echo "'   help - display available commands                       '" 
@echo "'                                                           '"
@echo "' Tasks availables:                                         '"
@echo "'   --release - use for first version of project            '"
@echo "'   --relup - use for generate version of upgrage           '"
@echo "'             this task need: src\%app_name%.appup          '"
@echo "'                                                           '"
@echo "'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''"
@goto :eof


:: Task Release
:task_release
@call:compile
@call:release
@call:tar
@goto :eof


:: Task Relup
:task_relup
@call:compile
@copy "src\%app_name%.appup.src" "ebin\%app_name%.appup" >NUL
@call:release
@call:relup
@call:tar
@goto :eof


:: Release
:release
@escript _eautomatize\relx release
@goto :eof


:: Relup
:relup
@escript _eautomatize\relx relup
@goto :eof


:: Tar
:tar
@escript _eautomatize\relx tar
@goto :eof


:: Compile
:compile
@DEL /s /q /f ebin
@FOR /R "src" %%G in (*.erl) DO @erlc -v %erlc_options% -o ebin/ "%%G" -pa ebin/
@copy "src\%app_name%.app.src" "ebin\%app_name%.app" >NUL
@goto :eof


:: Doc
:doc
@erl -noshell -eval "edoc:application(%app_name%, src, [{dir, doc}])" -s init stop
@goto :eof


:: Gen Structure
:gen_structure
@if "%2"=="otp" @(
    @mkdir config
    @mkdir doc
    @mkdir ebin
    @mkdir priv
    @mkdir src
    @mkdir test


    @echo [> config\sys.config
    @echo ].>> config\sys.config


    @echo -name %app_name%@127.0.0.1> config\vm.args
    @echo -setcookie %app_name%>> config\vm.args
    @echo -heart>> config\vm.args


    @echo {application, %app_name%,> src\%app_name%.app.src
    @echo  [{description, "An OTP application"},>> src\%app_name%.app.src
    @echo    {vsn, "0.0.1"},>> src\%app_name%.app.src
    @echo    {registered, []},>> src\%app_name%.app.src
    @echo    {mod, { %app_name%_app, []}},>> src\%app_name%.app.src
    @echo    {applications,>> src\%app_name%.app.src
    @echo    [kernel,>> src\%app_name%.app.src
    @echo      stdlib,>> src\%app_name%.app.src
    @echo      sasl>> src\%app_name%.app.src
    @echo    ]},>> src\%app_name%.app.src
    @echo    {env,[]},>> src\%app_name%.app.src
    @echo    {modules, [%app_name%_app, %app_name%_sup]},>> src\%app_name%.app.src
    @echo    {maintainers, []},>> src\%app_name%.app.src
    @echo    {licenses, ["Apache 2.0"]},>> src\%app_name%.app.src
    @echo    {links, []}>> src\%app_name%.app.src
    @echo  ]}.


    @echo {release, {%app_name%, "0.0.1"}, [%app_name%, sasl, kernel, stdlib]}.> relx.config
    @echo {extended_start_script, true}.>> relx.config
    @echo {include_erts, true}.>> relx.config
    @echo {include_src, false}.>> relx.config


    @echo {"0.0.2",> src\%app_name%.appup.src
    @echo   [{"0.0.1",>> src\%app_name%.appup.src
    @echo     [{load_module, %app_name%_app},>> src\%app_name%.appup.src
    @echo      {update, %app_name%_newModule}]}],>> src\%app_name%.appup.src
    @echo   [{"0.0.1",>> src\%app_name%.appup.src
    @echo     [{load_module, %app_name%_app}]}]}.>> src\%app_name%.appup.src
    
    
    @copy "_eautomatize\example_src_app_otp.txt" "src\example_src_app_otp.txt" >NUL
)
@if "%2"=="" @(
  @goto help
)
@goto :eof


:: Deps
:compile_dep
@IF EXIST "_eautomatize/deps/%2.cmd" (
  @call _eautomatize/deps/%2.cmd
) ELSE (
  @echo Ow No!
  @echo   I still do not know how to work with this dependency.
  @echo   Create a Pull request to creator insert in next version.
)
@goto :eof
