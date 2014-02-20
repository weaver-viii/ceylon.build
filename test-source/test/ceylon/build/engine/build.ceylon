import ceylon.build.engine { runEngine, EngineResult, noGoalToRun, errorOnTaskExecution, success, GoalDefinitionsBuilder, Goal, GoalProperties }
import ceylon.build.task { Writer }
import ceylon.test { test, assertEquals }
import ceylon.collection { MutableList, LinkedList }

String failingGoal1 = "failingGoal1";
String failingGoal2 = "failingGoal2";
String failingGoal3 = "failingGoal3";
String goalWithoutTask = "goalWithoutTask";
String goalWithATask = "goalWithATask";
String internalGoal = "internalGoal";
String goalWithOnlyDependencies = "goalWithOnlyDependencies";
String goalWithOnlyDependenciesOnGoalsWithoutTask = "goalWithOnlyDependenciesOnGoalsWithoutTask";

[String+] availableGoals = [
    failingGoal1,
    failingGoal2,
    failingGoal3,
    goalWithoutTask,
    goalWithATask,
    internalGoal,
    goalWithOnlyDependencies,
    goalWithOnlyDependenciesOnGoalsWithoutTask
];

String ceylonBuildStartMessage = "## ceylon.build";
String noGoalToRunMessage = "# no goal to run, available goals are: ``availableGoals``";

test void shouldExitWhenNoGoalToRun() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = [];
    checkExecutionResult {
        result = execute(goalsToRun, writer, executedTasks);
        status = noGoalToRun;
        available = sort(availableGoals);
        toRun = [];
        successful = [];
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages = [ceylonBuildStartMessage];
        errorMessages = [noGoalToRunMessage];
    };
    assertEquals(executedTasks, []);
}

test void shouldExitWhenNoGoalWithTasksToRun() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = [goalWithoutTask];
    checkExecutionResult {
        result = execute(goalsToRun, writer, executedTasks);
        status = noGoalToRun;
        available = sort(availableGoals);
        toRun = [];
        successful = [];
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages = [ceylonBuildStartMessage];
        errorMessages = [noGoalToRunMessage];
    };
    assertEquals(executedTasks, []);
}

test void shouldExecuteGoal() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = [goalWithATask];
    checkExecutionResult {
        result = execute(goalsToRun, writer, executedTasks);
        status = success;
        available = sort(availableGoals);
        toRun = goalsToRun;
        successful = goalsToRun;
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages = [ceylonBuildStartMessage,
            "# running goals: [``goalWithATask``] in order",
            "# running ``goalWithATask``()"];
        errorMessages = [];
    };
    assertEquals(executedTasks, goalsToRun);
}

test void shouldExecuteInternalGoal() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = [internalGoal];
    checkExecutionResult {
        result = execute(goalsToRun, writer, executedTasks);
        status = success;
        available = sort(availableGoals);
        toRun = goalsToRun;
        successful = goalsToRun;
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages = [ceylonBuildStartMessage,
            "# running goals: [``internalGoal``] in order",
            "# running ``internalGoal``()"];
        errorMessages = [];
    };
    assertEquals(executedTasks, goalsToRun);
}

test void shouldExecuteDependencies() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = [goalWithOnlyDependencies];
    checkExecutionResult {
        result = execute(goalsToRun, writer, executedTasks);
        status = success;
        available = sort(availableGoals);
        toRun = [goalWithATask];
        successful = [goalWithATask];
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages = [ceylonBuildStartMessage,
        "# running goals: [``goalWithATask``] in order",
        "# running ``goalWithATask``()"];
        errorMessages = [];
    };
    assertEquals(executedTasks, [goalWithATask]);
}

test void shouldExitWhenNoGoalWithTasksToRunEvenOnDependencies() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = [goalWithOnlyDependenciesOnGoalsWithoutTask];
    checkExecutionResult {
        result = execute(goalsToRun, writer, executedTasks);
        status = noGoalToRun;
        available = sort(availableGoals);
        toRun = [];
        successful = [];
        failed = [];
        notRun = [];
        writer = writer;
        infoMessages = [ceylonBuildStartMessage];
        errorMessages = [noGoalToRunMessage];
    };
    assertEquals(executedTasks, []);
}

test void shouldExecuteFailingGoal() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = [failingGoal2];
    checkExecutionResult {
        result = execute(goalsToRun, writer, executedTasks);
        status = errorOnTaskExecution;
        available = sort(availableGoals);
        toRun = goalsToRun;
        successful = [];
        failed = goalsToRun;
        notRun = [];
        writer = writer;
        infoMessages = [ceylonBuildStartMessage,
            "# running goals: [``failingGoal2``] in order",
            "# running ``failingGoal2``()"];
        errorMessages = ["# goal ``failingGoal2`` failure, stopping", "boom"];
    };
    assertEquals(executedTasks, []);
}

test void shouldExecuteGoalsUntilFailure() {
    value executedTasks = LinkedList<String>();
    value writer = MockWriter();
    value goalsToRun = [failingGoal3];
    checkExecutionResult {
        result = execute(goalsToRun, writer, executedTasks);
        status = errorOnTaskExecution;
        available = sort(availableGoals);
        toRun = [failingGoal1, failingGoal2, failingGoal3];
        successful = [failingGoal1];
        failed = [failingGoal2];
        notRun = [failingGoal3];
        writer = writer;
        infoMessages = [ceylonBuildStartMessage,
            "# running goals: [``failingGoal1``, ``failingGoal2``, ``failingGoal3``] in order",
            "# running ``failingGoal1``()", "# running ``failingGoal2``()"];
        errorMessages = ["# goal ``failingGoal2`` failure, stopping", "boom"];
    };
    assertEquals(executedTasks, [failingGoal1]);
}

EngineResult execute([String*] arguments, Writer writer, MutableList<String> executedTasks) {
    value builder = GoalDefinitionsBuilder {
        Goal {
            name = goalWithoutTask;
            properties = GoalProperties {
                internal = false;
                task = null;
                dependencies = [];
            };
        },
        Goal {
            name = goalWithATask;
            properties = GoalProperties {
                internal = false;
                task() => executedTasks.add(goalWithATask);
                dependencies = [];
            };
        },
        Goal {
            name = internalGoal;
            properties = GoalProperties {
                internal = false;
                task() => executedTasks.add(internalGoal);
                dependencies = [];
            };
        },
            name = goalWithOnlyDependencies;
            properties = GoalProperties {
                internal = false;
                task = null;
                dependencies = [goalWithoutTask,goalWithATask];
            };
        },
        Goal {
            name = goalWithOnlyDependenciesOnGoalsWithoutTask;
            properties = GoalProperties {
                internal = false;
                task = null;
                dependencies = [goalWithoutTask];
            };
        },
        Goal {
            name = failingGoal1;
            properties = GoalProperties {
                internal = false;
                task() => executedTasks.add(failingGoal1);
                dependencies = [];
            };
        },
        Goal {
            name = failingGoal2;
            properties = GoalProperties {
                internal = false;
                task = void() { throw Exception("boom"); };
                dependencies = [];
            };
        },
        Goal {
            name = failingGoal3;
            properties = GoalProperties {
                internal = false;
                task() => executedTasks.add(failingGoal3);
                dependencies = [failingGoal1,failingGoal2];
            };
        }
    };
    return runEngine {
        goals = builder;
        arguments = arguments;
        writer = writer;
    };
}
