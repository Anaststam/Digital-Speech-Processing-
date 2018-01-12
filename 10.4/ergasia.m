close( 'all' )
clear all

%erwthma 1,2%

filenames = { };
for i = 1:9
    filenames{end+1} = [ num2str(i) 'A.wav' ];
    filenames{end+1} = [ num2str(i) 'B.wav' ];
end

filenames{end+1} = [ 'OA.wav' ];
filenames{end+1} = [ 'OB.wav' ];
filenames{end+1} = [ 'ZA.wav' ];
filenames{end+1} = [ 'ZB.wav' ];

for z = 1:numel( filenames )

    [y,Fs] = audioread( [ '..\matlab\chapter_10\tidigits_isolated_unendpointed\' filenames{z} ] );

    [p,q] = rat(8000/Fs,0.0001);
    y2 = resample(y,p,q);

    %erwthma 4%
    NS=40;
    L=NS*8;
    MS=10;
    R=MS*8;

    filter_apply

    %erwthma 5%
    e6A=ShortTimeEnergy(yfiltered,L,R);
    e6A = 10*log10(e6A) -max( 10*log10(e6A) );
    zcr6A=ShortTimeZeroCrossingRate(yfiltered,L,R);

    %erwthma 6%
    E10 = e6A(1:10); %ta prwta deka plaisia ths energeias
    ZCR10 = zcr6A(1:10); %ta prwta deka plaisia tou zcr

    eavg6A = mean(E10); %mesh timh logarithmikihs energeias
    esig6A = std(E10); %tipiki apoklisi logar energeias
    zcavg6A = mean(ZCR10);
    zcsig6A = std(ZCR10);

    %erwthma7%
    IF = 35;
    IZCT = max( IF, zcavg6A + 3*zcsig6A );
    IMX = max(e6A);
    ITU = IMX-20;
    ITL = max( eavg6A+3*esig6A, ITU-10 );

    %erwthma8%
    maxE = max(e6A) %megisth timh energeias 
    location = find(e6A==maxE) %thesh opou brisketai h megisth timh energeias

    theseis =[];
    for i = 1:length(e6A) % poia stoixeia einai mikrotera ths ITU
        if e6A(i) < ITU
            theseis(i) = i;
        else
            theseis(i) = 0;
        end
    end 

    k2=find(~theseis);
    akro1=k2(1)-1 %akroA perioxis kurias sugkentrwshs ths energeias 
    akro2=k2(end)+1 %akroB perioxis kurias sugkentrwshs ths energeias 

    theseis2=[];
    for i=1:length(e6A) % h perioxh me thn megisth sugkentrwsh energeias den peftei katw apo to ITL
        if e6A(i)< ITL
            theseis2(i) = i;
        else
            theseis2(i) = 0;
        end
    end

    for i=1:length(zcr6A)
        if IZCT < zcr6A(i) % poia soixeia einai megalutera apo IZCT
            theseis3(i) = i;
        else
            theseis3(i) = 0;
        end
    end
    
    epektakro1 = akro1;
    epektakro2 = akro2;

    %epektetameno akro1 
    for i = max( 1, akro1-25 ):akro1
        if i + 3 <= numel( theseis3 )
            tmp = sum( theseis3( i:i+3 ) ~= 0 );
            if tmp == 4
                epektakro1 = theseis3(i);
                break;
            end
        end
    end
    
    %epektetameno akro 2
    for i = akro2:min( numel(theseis3), akro2+25 )
        if i + 4 <= numel( theseis3 )
            tmp = sum( theseis3( i:i+3 ) ~= 0 );
            if tmp == 4 && theseis3(i+4) == 0
                epektakro2 = theseis3(i+3);
            end
        end
    end
    
    %title( [ 'onoma arxeiou: ' filenames{z} ',L,R: ' num2str(L) ' ' num2str(R) ] ),
    tE = linspace( 0, 100, numel(e6A) );
    tZ = linspace( 0, 100, numel(zcr6A) );
    
    figure(1),
        subplot(2,2,[1,2]),
            plot( tE, e6A ),
            hold on,
            plot( akro1 + zeros(1, numel( min(e6A):max(e6A) ) ), min(e6A):max(e6A), '-r' ),
            plot( akro2 + zeros(1, numel( min(e6A):max(e6A) ) ), min(e6A):max(e6A), '-r' ),
            plot( epektakro1 + zeros(1, numel( min(e6A):max(e6A) ) ), min(e6A):max(e6A), '--b' ),
            plot( epektakro2 + zeros(1, numel( min(e6A):max(e6A) ) ), min(e6A):max(e6A), '--b' ),
            plot( 1:numel(e6A), ITU*ones( 1, numel(e6A) ), '-.g' ),
            plot( 1:numel(e6A), ITL*ones( 1, numel(e6A) ), '-.g' ),
            title( [ 'Energy Όνομα αρχείου: ' filenames{z} ',L,R: ' num2str(L) ' ' num2str(R) ] ),
            xlabel('Αριθμός πλαισίου'),
            ylabel('Λογαριθμική ενέργεια (dB)'),
            hold off,
        subplot(2,2,[3,4]),
            plot( tZ, zcr6A ),
            hold on,
            plot( akro1 + zeros(1, numel( min(zcr6A):max(zcr6A) ) ), min(zcr6A):max(zcr6A), '-r' ),
            plot( akro2 + zeros(1, numel( min(zcr6A):max(zcr6A) ) ), min(zcr6A):max(zcr6A), '-r' ),
            plot( epektakro1 + zeros(1, numel( min(zcr6A):max(zcr6A) ) ), min(zcr6A):max(zcr6A), '--b' ),
            plot( epektakro2 + zeros(1, numel( min(zcr6A):max(zcr6A) ) ), min(zcr6A):max(zcr6A), '--b' ),
            plot( 1:numel(zcr6A), IZCT*ones( 1, numel(zcr6A) ), '-.g' ),
            title( 'Zero Crossing Rate' ),
            xlabel('Αριθμός πλαισίου'),
            ylabel('Zc ανά 10msec'),
            hold off;
            
        print( [ 'figures/' filenames{z} '.png' ],'-dpng');
        
        voice=[];
		voice=yfiltered( epektakro1*R:epektakro2*R);
        sound(voice,8000)
end