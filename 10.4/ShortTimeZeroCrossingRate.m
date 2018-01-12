% FUNCTION ShortTimeZeroCrossingRate : windowLength and step in # of samples

function ZCR = ShortTimeZeroCrossingRate(signal, windowLength,step)

    curPos = 1;
    L = length(signal);
    ZCR = [];
    frameCounter=1;
    while (curPos+windowLength-1<=L)    
        window = (signal(curPos:curPos+windowLength-1));
        temp=0;
        for i=2:windowLength
            temp = temp + abs( sgn(window(i)) - sgn(window(i-1)) );
        end    
        ZCR(frameCounter) = temp;
        curPos = curPos + step;
        frameCounter=frameCounter+1;
    end

    ZCR = ( ZCR * step ) / ( 2 * windowLength );
    
end