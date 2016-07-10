%% Expression - Create phenotype from genotype. Wrapper with execution timer.

express_start = tic;

if p.parallel
    parfor i=1:length(pop)
        pop(i).pheno = express(pop(i),p);
    end
else
    for i=1:length(pop)
        pop(i).pheno = express(pop(i),p);
    end
end

express_time(gen) = toc(express_start);