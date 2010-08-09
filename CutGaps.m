function [TimeFrac Data] = QAWavelet(TimeFrac, Data, Gaps)

Gaps
for i=1:size(Gaps,2)
    YearFrac(find(YearFrac == Gaps{i}(1))) = []
end

for i=1:size(iGaps,2)
    % take down the start/end yearfracs for the gaps so we can
    % cut the data at the end
    Gaps = [TimeFrac(iGaps(i)) TimeFrac(iGaps(i)+1)]
end