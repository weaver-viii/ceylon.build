import ceylon.build.task { Task, Context }

"Compiles a Ceylon module using `ceylon compile` command line."
shared Task compile(
        doc("name of module to compile")
        String moduleName,
        doc("encoding used for reading source files
             (default: platform-specific)
             (corresponding command line parameter: `--encoding=<encoding>`)")
        String? encoding = "",
        doc("Path to source files
             (default: './source')
             (corresponding command line parameter: `--src=<dirs>`)")
        {String*} sourceDirectories = [],
        doc("Passes an option to the underlying java compiler
             (corresponding command line parameter: `--javac=<option>`)")
        String? javacOptions = null,
        doc("Specifies the output module repository (which must be publishable).
             (default: './modules')
             (corresponding command line parameter: `--out=<url>`)")
        String? outputModuleRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String? dependenciesRepository = null,
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Sets the user name for use with an authenticated output repository
             (corresponding command line parameter: `--user=<name>`)")
        String? user = null,
        doc("Sets the password for use with an authenticated output repository
             (corresponding command line parameter: `--pass=<secret>`)")
        String? password = null,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("Disables the default module repositories and source directory.
             (corresponding command line parameter: `--d`)")
        Boolean disableModuleRepository = false,
        doc("Produce verbose output.
             (corresponding command line parameter: `--verbose=<flags>`)")
        {CompileVerboseMode*}|AllVerboseModes verboseModes = [],
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable
) {
    return function(Context context) {
        value command = buildCompileCommand {
            ceylon;
            moduleName;
            encoding;
            sourceDirectories;
            javacOptions;
            outputModuleRepository;
            dependenciesRepository;
            systemRepository;
            user;
            password;
            offline;
            disableModuleRepository;
            verboseModes;
            context.arguments;
        };
        return execute(context.writer, "compiling", command);
    };
}

"Compiles a Ceylon module to javascript using `ceylon compile-js` command line."
shared Task compileJs(
        doc("name of module to compile")
        String moduleName,
        doc("encoding used for reading source files
             (default: platform-specific)
             (corresponding command line parameter: `--encoding=<encoding>`)")
        String? encoding = null,
        doc("Path to source files
             (default: './source')
             (corresponding command line parameter: `--src=<dirs>`)")
        {String*} sourceDirectories = [],
        doc("Specifies the output module repository (which must be publishable).
             (default: './modules')
             (corresponding command line parameter: `--out=<url>`)")
        String? outputModuleRepository = null,
        doc("Specifies a module repository containing dependencies. Can be specified multiple times.
             (default: 'modules', '~/.ceylon/repo', http://modules.ceylon-lang.org)
             (corresponding command line parameter: `--rep=<url>`)")
        String? dependenciesRepository = null,
        doc("Specifies the system repository containing essential modules.
             (default: '$CEYLON_HOME/repo')
             (corresponding command line parameter: `--sysrep=<url>`)")
        String? systemRepository = null,
        doc("Sets the user name for use with an authenticated output repository
             (corresponding command line parameter: `--user=<name>`)")
        String? user = null,
        doc("Sets the password for use with an authenticated output repository
             (corresponding command line parameter: `--pass=<secret>`)")
        String? password = null,
        doc("Enables offline mode that will prevent the module loader from connecting to remote repositories.
             (corresponding command line parameter: `--offline`)")
        Boolean offline = false,
        doc("Equivalent to '--no-indent' '--no-comments'
             (corresponding command line parameter: `--compact`)")
        Boolean compact = false,
        doc("Do NOT generate any comments
             (corresponding command line parameter: `--no-comments`)")
        Boolean noComments = false,
        doc("Do NOT indent code
             (corresponding command line parameter: `--no-indent`)")
        Boolean noIndent = false,
        doc("Do NOT wrap generated code as CommonJS module
             (corresponding command line parameter: `--no-module`)")
        Boolean noModule = false,
        doc("Create prototype-style JS code
             (corresponding command line parameter: `--optimize`)")
        Boolean optimize = false,
        doc("Time the compilation phases (results are printed to standard error)
             (corresponding command line parameter: `--offline`)")
        Boolean profile = false,
        doc("Do NOT generate .src archive - useful when doing joint compilation
             (corresponding command line parameter: `--skip-src-archive`)")
        Boolean skipSourceArchive = false,
        doc("Print messages while compiling
             (corresponding command line parameter: `--verbose`)")
        Boolean verbose = false,
        doc("Ceylon executable that will be used")
        String ceylon = ceylonExecutable
) {
    return function(Context context) {
        value command = buildCompileJsCommand {
            ceylon;
            moduleName;
            encoding;
            sourceDirectories;
            outputModuleRepository;
            dependenciesRepository;
            systemRepository;
            user;
            password;
            offline;
            compact;
            noComments;
            noIndent;
            noModule;
            optimize;
            profile;
            skipSourceArchive;
            verbose;
            context.arguments;
        };
        return execute(context.writer, "compiling", command);
    };
}