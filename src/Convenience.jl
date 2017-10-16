module convenience
using DataFrames, RDatasets
#import StatsBase.sem
export sem

@doc """
Compute the standard error of the mean (SEM) and confidence intervals given a dataset, a dependent variable of interest, an id variable (e.g., "subjects" or "items"), and a set of grouping variables (e.g., "condition").
      """ ->
function sem(dat, dv, id, conds; limit = 1.96, returnIntermediate = false)
      means = by(dat, vcat(id, conds), df->DataFrame(M = mean(df[dv])))

      submeans = by(means, conds, df->DataFrame(M = mean(df[:M]),
      SD = std(df[:M]), N = size(df,1)))

      submeans[:SEM] = submeans[:SD] ./ sqrt(submeans[:N])
      submeans[:upper] = submeans[:M] + limit*submeans[:SEM]
      submeans[:lower] = submeans[:M] - limit*submeans[:SEM]

      if(returnIntermediate)
            return submeans,means
      else
            return submeans
      end
end
end
