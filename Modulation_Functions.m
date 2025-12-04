function [m, p, modulatedSignal, demodulatedSignal] = modulationFunctions(t, m, Ts, T, A, modulationType, sawth)
    switch modulationType
        case 'PAM'
            fs = 1/(t(2)-t(1));
            fc= 1/Ts;
            duty=T*100;
            
            % Modulation
            p=0.5*square(2*pi*fc*t, duty)+0.5;
            modulatedSignal=m.*p;

            % Demodulation
            d=modulatedSignal.*p; 
            filter=fir1(200,2/fs,'low'); 
            demodulatedSignal=conv(filter,d); 
            demodulatedSignal = 4 * demodulatedSignal;
        case 'Flat-top PAM'
            fs = 1/(t(2)-t(1));
            fc = 1/Ts;
            duty=T*100;

            p=0.5*square(2*pi*fc*t , duty)+0.5;
            width_samp=floor(length(t)/fc);
            in=1:width_samp:length(t);
            on=ceil(width_samp*duty/100);
            
            % Modulation
            pam=zeros(1, length(t));
            for i=1:length(in)
             pam(in(i):in(i)+on)=m(in(i));
            end
            modulatedSignal = pam;
            if(length(modulatedSignal) ~= length(t))
                x = floor((length(modulatedSignal) - length(t))/2);
                modulatedSignal = modulatedSignal(x:length(modulatedSignal)-x-1);
            end
            % Demodulation
            dt=p.*modulatedSignal;

            filter=fir1(200,2/fs,'low');
            demodulatedSignal=conv(filter,dt);
            demodulatedSignal = 10 * demodulatedSignal;
        case 'PWM'
            fs = 1/(t(2)-t(1));
            p = sawth;
            samplesNum = t(end)/Ts;
            spacingNum = numel(m); % get the length of m
            sample_width = round(spacingNum / samplesNum);
            sampled_signal = resample(m, 1, sample_width); % equally spaced samples
            starting_edges = 0:Ts:t(end);
            ending_edges = zeros(size(starting_edges));
            widths = rescale(sampled_signal, 1/fs, Ts-1/fs);

            % Modulation
            for i=1:length(starting_edges)
                ending_edges(i) = starting_edges(i) + widths(i);
            end
            pwm = zeros(size(t));
            for i = 1:length(starting_edges)
                idx_start = find(t >= starting_edges(i), 1);
                idx_end = find(t >= ending_edges(i), 1);
                pwm(idx_start:idx_end) = A;
            end
            modulatedSignal = pwm;
            
            % Demodulation
            samples_message_signal = linspace(0, t(end), length(widths));
            demodulatedSignal = interp1(samples_message_signal, widths, t, 'spline'); 
            demodulatedSignal = 20 * demodulatedSignal;
        case 'PPM'
            fs = 1/(t(2)-t(1));
            p = sawth;
            samplesNum = t(end)/Ts;
            spacingNum = numel(m); % get the length of m
            sample_width = round(spacingNum / samplesNum);
            sampled_signal = resample(m, 1, sample_width); % equally spaced samples
            starting_edges = 0:Ts:t(end);
            ending_edges = zeros(size(starting_edges));
            widths = rescale(sampled_signal, 1/fs, Ts-1/fs);
            
            % Modulation
            for i=1:length(starting_edges)
                ending_edges(i) = starting_edges(i) + widths(i);
            end
            ppm = zeros(size(t));
            for i = 1:length(starting_edges)
                idx_start = find(t >= starting_edges(i), 1);
                idx_end = find(t >= ending_edges(i), 1);
                ppm(idx_start:idx_end) = A;
            end
            check_starting = true;
            check_ending = true; 
            modulatedSignal = zeros(size(m));
            for i=1:(length(sawth) - 1)
                if(ppm(i) == A && ppm(i+1) == A && check_starting)
                    modulatedSignal(i) = A;
                    check_starting = false;
                    check_ending = true;
                end
                if(ppm(i) == A && ppm(i+1) == 0 && check_ending)
                    modulatedSignal(i) = 2;
                    check_starting = true;
                    check_ending = false;
                end
            end

            % Method 2 for Modulation: 
%             for i=1:length(sawtooth)
%                 if (msg(i)>=sawtooth(i))
%                     pwm(i)=A;
%                 else
%                     pwm(i)=0;
%                 end
%             end

            % Demodulation
            samples_message_signal = linspace(0, t(end), length(widths));
            demodulatedSignal = interp1(samples_message_signal, widths, t, 'spline'); 
            demodulatedSignal = 20 * demodulatedSignal;
        otherwise
            disp('other value')
    end
end
