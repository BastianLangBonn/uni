function [ fitness ] = evaluate3Inputs( wMat, targetFitness )
%EVALUATE6INPUTS Evaluation function for 3 inputs. Passes RNNet2 as a
%parameter to twoPole_test.
    fitness = feval('twoPole_test',...
                wMat,...
                @RNNet2,...
                targetFitness);

end

