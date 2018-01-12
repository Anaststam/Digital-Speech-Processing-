close( 'all' )
clear

tic

load( '..\matlab\chapter_10\nonspeech.mat' );%load logen, zcn
load( '..\matlab\chapter_10\speech.mat' );%load loges, zcs

%dilosi mitroon xaraktiristikon
X_nonspeech = [ logen' zcn' ];
X_speech = [ loges' zcs' ];

%Υπολογισμός μέσης τιμής και τυπικής για την 1η κλάσση
for i = 1:2
    m1_hat(i) = mean( X_nonspeech(:, i )' );
    s1_hat(i) = std( X_nonspeech( :, i ) );
end

%m1_hat
%s1_hat

m1_hat = m1_hat';
s1_hat = s1_hat';

%Υπολογισμός μέσης τιμής και τυπικής απόκλισης για την 2η κλάσση
for i = 1:2
    m2_hat(i) = mean( X_speech( :, i )' );
    s2_hat(i) = std( X_speech( :, i ) );
end

%m2_hat
%s2_hat

m2_hat = m2_hat';
s2_hat = s2_hat';

%dimiourgia onomaton arxeion ixou
filenames = { };
for i = 1:9
    filenames{end+1} = [ num2str(i) 'A.wav' ];
    filenames{end+1} = [ num2str(i) 'B.wav' ];
end

filenames{end+1} = [ 'OA.wav' ];
filenames{end+1} = [ 'OB.wav' ];
filenames{end+1} = [ 'ZA.wav' ];
filenames{end+1} = [ 'ZB.wav' ];

%gia kathe arxeio
for z = 1:numel( filenames )
    
    %fortoma arxeiou
    [ys,fs] = wavread( [ '..\matlab\chapter_10\tidigits_isolated_unendpointed\' filenames{z} ] );

    neo_fs = 8000;
    [p,q] = rat(neo_fs/fs,0.0001);

    %deigmatolipsia se 8000hz apo 20000hz
    ys = resample(ys,p,q);

    fs = neo_fs;
    y_neo = ys;

    N = numel( ys );
    n = 0:N-1;
    ts = n / fs;

    t = linspace( 0, 200, numel(ys) );

    NS = 40;
    MS = 10;

    L = NS * 8;
    R = MS * 8;
   
    %filtro
    Fs = 8000;  % Sampling Frequency

    N     = 10;   % Order
    Fstop = 100;  % Stopband Frequency
    Fpass = 200;  % Passband Frequency
    Wstop = 1;    % Stopband Weight
    Wpass = 1;    % Passband Weight
    dens  = 20;   % Density Factor
    %N = numel( ys );
    % Calculate the coefficients using the FIRPM function
    b  = firpm(N, [0 Fstop Fpass Fs/2]/(Fs/2), [0 0 1 1], [Wstop Wpass], ...
               {dens});
    Hd = dfilt.dffir(b);
   
    y = filter(Hd,ys);

    %ypologismos energeias kai zero crossrating
    E = ShortTimeEnergy( ys, L, R );
    tE = linspace( 0, 100, numel(E) );
    Z = ShortTimeZeroCrossingRate( ys, L, R );

    tZ = linspace( 0, 100, numel(Z) );
    
    NE = 10*log10(E) -max( 10*log10(E) );

    %topothesi ton meson timon kai ton typikon apoklieseon
    %se mitroo oste na ypologisoume kalytera tis apostaseis d kai tin
    %axiopistia c
    m = [ m1_hat'; m2_hat' ];
    s = [ s1_hat'; s2_hat' ];

    Y = [];%krataei times 1 i 2 gia tis klasseis

    C1 = [];%ebistosini klassis 1 gia to i-osto plaisio
    C2 = [];%ebistosini klassis 2 gia to i-osto plaisio

    Con = [];%ebistosini klassis 1 i 2 pou kerdise gia to i-osto plaisio

    %gia ola ta plaisia
    for i = 1:numel( NE )

        X = [ NE(i); Z(i) ];%pairnoume ta xaraktiristika tou

        d = [ 0; 0 ];%kratame topika tin apostasi

        %ypologizoume tis apostaseis
        for j = 1:2

            tot = 0;

            for k = 1:2
                tot = tot + ( ( X(k) - m(j,k) ) * ( X(k) - m(j,k) ) ) / ( s(j,k) * s(j,k) );
            end

            d(j) = tot;

        end

        %ypologizoume tis axiopisties
        c1 = ( d(2) ) / ( d(1) + d(2) );
        c2 = ( d(1) ) / ( d(1) + d(2) );
        
        %apothikeuoume tis axiopisties
        C1 = [ C1 c1 ];
        C2 = [ C2 c2 ];
    
        %vlepoume poia klassi yperteri
        if d(1) < d(2)
            if c1 >= 0.75
                Y(i) = 1;
                Conf(i) = c1;
            else
                Y(i) = 2;
                Conf(i) = c2;
            end
        else
            if c2 >= 0.75
                Y(i) = 2;
                Conf(i) = c2;
            else
                Y(i) = 1;
                Conf(i) = c1;
            end
        end

    end
    
    figure(1),
        subplot(2,2,[1 2]),
            plot( 1:numel(Y), Y ),
            hold on,  plot( 1:numel(Conf), Conf+1, '-.r' ),
            hold on, plot( 1:numel(Conf), 0.75*ones( 1, size(Conf,2) ) + 1, '-.g' ),
            legend('Κλάσση','Εμπιστοσύνη ανυψωμένη κατά 1', 'Κατώφλι ανυψωμένο κατά 1', 'Location', 'northoutside', 'Orientation', 'horizontal' ),
            title( [ 'Όνομα αρχείου: ' filenames{z} ',L,R: ' num2str(L) ' ' num2str(R) ] ),
            xlabel('Αριθμός πλαισίου'),
            ylabel('NS')
            axis( [ 1 numel(Y) 0.5 2.5 ] ),
        subplot(2,2,3),
            plot( tE, NE ),
            title( 'Energy' ),
            xlabel('Αριθμός πλαισίου'),
            ylabel('Λογαριθμική ενέργεια (dB)'),
        subplot(2,2,4),
            plot( tZ, Z ),
            title( 'Zero Crossing Rate' ),
            xlabel('Αριθμός πλαισίου'),
            ylabel('Zc ανά 10msec'),
        hold off;
        
    print( [ 'figures/' filenames{z} '.png' ],'-dpng');
    
end

toc