%% getRunData.m - Compiles data from one completed run into a single struct

% Parameter Set
runData.p               = p;

% Performance data
runData.fit             = fit;
runData.spec            = spec;
runData.nodes           = nodes;
runData.conns           = conns;
runData.innovation      = innovation;

% Runtime Data
runData.eval_time       = eval_time;
runData.express_time    = express_time;
runData.speciate_time   = speciate_time;
runData.recom_time      = recom_time;

% Solution Data
runData.elite           = elite;
runData.population      = pop;
if exist('solveGen','var')
    runData.solveGen =  solveGen;
else
    runData.solvedGen = 0;
end
