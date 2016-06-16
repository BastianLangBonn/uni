function [ fitness ] = evaluate6Inputs( wMat, targetFitness )
%EVALUATION6INPUTS Evaluation function for 6 inputs. Passes RNNet as the
%evaluation function to twoPole_test.
    fitness = feval('twoPole_test',...
                wMat,...
                @RNNet,...
                targetFitness);

end

