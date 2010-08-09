function [TimeFrac Data] = TransformData(TimeFrac, Data, Interactive, ChunkNumber)

Data.OutputData = (Data.OutputData - mean(Data.OutputData))/std(Data.OutputData);

if Interactive
    figure(100 + ChunkNumber); clf;
    plot(TimeFrac, Data.OutputData);
    title(['Transformed Data for Segment ' num2str(ChunkNumber)]);
end