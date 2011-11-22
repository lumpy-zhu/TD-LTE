function loss=pathloss(scmpar,linkpar)
%PATHLOSS Pathloss models for 2GHz and 5GHz
%   PATH_LOSSES=PATHLOSS(SCMPAR,LINKPAR) returns path losses in dB scale
%   for all links defined in SCM input struct LINKPAR for the center
%   frequency and scenario given in SCMPAR. The output is a column vector
%   whose length is equal to the number of links defined in LINKPAR, e.g.
%   LENGTH(LINKPAR.MsBsDistance). The center frequencies and distances
%   must be specified in Herzes and meters, respectively.
%
%   Currently PATHLOSS supports 2 GHz and 5GHz center frequencies and
%   the SCM scenarios: suburban macro, urban macro, and urban micro [1].
%   MS and BS heights are not currently supported.
%
%   The 2GHz path loss model is based on [1, Table 5.1]. The 5 GHz path
%   loss model (Nokia pathloss model) is based on Nokia's measurements at
%   5.25 GHz frequency [2].
%
%   Refs.   [1]: 3GPP TR 25.996 v6.1.0 (2003-09)
%           [2]: https://bscw.eurescom.de/bscw/bscw.cgi/0/42903
%
%   See also SCMPARSET and LINKPARSET.

%   Authors: Jari Salo (HUT), Daniela Laselva (EBIT), Marko Milojevic (TUI)
%   $Revision: 0.12 $  $Date: May 30, 2005$



% extract required parameters from the input structs
NumUsers=length(linkpar.MsBsDistance);
MsBsDistance=linkpar.MsBsDistance;
Scenario=scmpar.Scenario;
CenterFrequency=scmpar.CenterFrequency;
Options=scmpar.ScmOptions;

% Note: currently only center frequencies equal to 2GHz and 5GHz are supported
% If center frequency is not supported by the model, it is changed to the
% closest frequency supported
CenterFrequency=1e9*round(CenterFrequency/1e9);         % Figure out center frequency by rounding to nearest GHz

switch (CenterFrequency)

    case(2e9)
        %disp('Note: CenterFrequency=2e9, Pathloss computation according to SCM pathloss model.')

    case(5e9)
        %disp('Note: CenterFrequency=5e9, Pathloss computation according to Nokia pathloss model.')

    otherwise

        if abs(CenterFrequency-2e9)<abs(CenterFrequency-5e9);
            CenterFrequency=2e9;
            warning('MATLAB:CenterFrequencyChanged','Center frequency changed to 2GHz for path loss computation.')
        else
            CenterFrequency=5e9;
            warning('MATLAB:CenterFrequencyChanged','Center frequency changed to 5GHz for path loss computation.')
        end
end



switch lower(Scenario)

    case {'suburban_macro'}

        if ~strcmpi(scmpar.AlternativePathloss,'yes')

            switch lower(Options)
                case {'none','polarized','urban_canyon'}
                    switch (CenterFrequency)
                        case (2e9)                      % SCM suburban_macro [DefaultPathloss. 1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<35)   % MsBsDistance range for macro=_max=3km
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 31.5 + 35.0 * log10(MsBsDistance);

                        case (5e9)                      % SCM suburban pathloss model calculated at 5GHz
                            if (min(MsBsDistance)<35)   % MsBsDistance range for macro=_max=3km
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 31.5 + 8 + 35.0 * log10(MsBsDistance);        % Currently pathloss for SUBURBAN at 5GHz might be not reliable.

                    end

                case('los')
                    switch (CenterFrequency)
                        case (2e9)                      % SCM suburban_macro [DefaultPathloss. 1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<35)   % MsBsDistance range for macro=_max=3km
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 26.0 * log10(MsBsDistance);

                        case (5e9)                      % SCM suburban pathloss model calculated at 5GHz
                            if (min(MsBsDistance)<35)   % MsBsDistance range for macro=_max=3km
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 8 + 26.0 * log10(MsBsDistance);        % Currently pathloss for SUBURBAN at 5GHz might be not reliable.
                    end

                    warning('no SCM LOS path-loss is defined for suburban macro - urban micro LOS path-loss is used')

            end

        else

            switch lower(Options)
                case {'none','polarized','urban_canyon'}


                    switch (CenterFrequency)
                        case (2e9)                      % SCM suburban_macro [DefaultPathloss. 1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<35)   % MsBsDistance range for macro=_max=3km
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 7.17 + 38.0 * log10(MsBsDistance);

                        case (5e9)                      % SCM suburban pathloss model calculated at 5GHz
                            if (min(MsBsDistance)<35)   % MsBsDistance range for macro=_max=3km
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 7.17 + 8 + 38.0 * log10(MsBsDistance);         % Currently pathloss for SUBURBAN at 5GHz might be not reliable.

                    end

                case {'los'}
                    switch (CenterFrequency)
                        case (2e9)                      % SCM suburban_macro [DefaultPathloss. 1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<35)   % MsBsDistance range for macro=_max=3km
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 26.0 * log10(MsBsDistance);

                        case (5e9)                      % SCM suburban pathloss model calculated at 5GHz
                            if (min(MsBsDistance)<35)   % MsBsDistance range for macro=_max=3km
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 8 + 26.0 * log10(MsBsDistance);        % Currently pathloss for SUBURBAN at 5GHz might be not reliable.

                    end

            end

        end

        
        

    case {'urban_macro'}

        if ~strcmpi(scmpar.AlternativePathloss,'yes')

            switch lower(Options)
                case {'none','polarized','urban_canyon'}

                    switch (CenterFrequency)
                        case (2e9)                      % SCM urban_macro model [1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<35)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 34.5 + 35.0 * log10(MsBsDistance);

                        case (5e9)                     % Nokia pathloss model for urban_macro (NLOS)
                            if (min(MsBsDistance)<35)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 34.5 + 8 + 35.0 * log10(MsBsDistance);                 %3dB subtracted compared to original formula because of antenna gain
                    end
                case {'los'}
                    switch (CenterFrequency)
                        case (2e9)                      % SCM urban_macro model [1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<35)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 26.0 * log10(MsBsDistance);

                        case (5e9)                     % Nokia pathloss model for urban_macro (NLOS)
                            if (min(MsBsDistance)<35)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 8 + 26.0 * log10(MsBsDistance);                %3dB subtracted compared to original formula because of antenna gain
                    end

                    warning('no SCM LOS path-loss is defined for urban macro - urban micro LOS path-loss is used')
            end


        else

            switch lower(Options)
                case {'none','polarized','urban_canyon'}

                    switch (CenterFrequency)
                        case (2e9)                      % SCM urban_macro model [1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<35)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 11.14 + 38.0 * log10(MsBsDistance);

                        case (5e9)                     % Nokia pathloss model for urban_macro (NLOS)
                            if (min(MsBsDistance)<35)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 11.14 + 8 + 38.0 * log10(MsBsDistance);              %3dB subtracted compared to original formula because of antenna gain
                    end
                case {'los'}
                    switch (CenterFrequency)
                        case (2e9)                      % SCM urban_macro model [1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<35)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 26.0 * log10(MsBsDistance);

                        case (5e9)                     % Nokia pathloss model for urban_macro (NLOS)
                            if (min(MsBsDistance)<35)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 35 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 8 + 26.0 * log10(MsBsDistance);                %3dB subtracted compared to original formula because of antenna gain
                    end

            end

        end




    case {'urban_micro'}


        if ~strcmpi(scmpar.AlternativePathloss,'yes')

            % options for urban micro
            switch lower(Options)

                case {'none','polarized','urban_canyon'}

                    switch (CenterFrequency)
                        case (2e9)              % SCM urban_micro model [1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<20)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 20 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 34.53 + 38.0 * log10(MsBsDistance);

                        case (5e9)              % Nokia pathloss model for urban_micro (distance-fit based model)
                            if (min(MsBsDistance)<20)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 20 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 34.53 + 8 + 38.0 * log10(MsBsDistance);
                    end



                case ('los')

                    switch (CenterFrequency)
                        case (2e9)              % SCM urban_micro model [1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<20)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 20 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 26.0 * log10(MsBsDistance);

                        case (5e9)              % Nokia pathloss model for urban_micro (distance-fit based model)
                            if (min(MsBsDistance)<20)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 20 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 8 + 26.0 * log10(MsBsDistance);
                    end


            end % end options for urban micro


        else

            switch lower(Options)

                case {'none','polarized','urban_canyon'}

                    switch (CenterFrequency)
                        case (2e9)              % SCM urban_micro model [1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<20)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 20 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 31.81 + 40.5 * log10(MsBsDistance);

                        case (5e9)              % Nokia pathloss model for urban_micro (distance-fit based model)
                            if (min(MsBsDistance)<20)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 20 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 31.81 + 8 + 40.5 * log10(MsBsDistance);
                    end



                case ('los')

                    switch (CenterFrequency)
                        case (2e9)              % SCM urban_micro model [1, Section 5.2 and Table 5.1]
                            if (min(MsBsDistance)<20)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 20 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 26.0 * log10(MsBsDistance);

                        case (5e9)              % Nokia pathloss model for urban_micro (distance-fit based model)
                            if (min(MsBsDistance)<20)
                                warning('MATLAB:TooSmallMsBsDistance','MsBsDistance less than 20 meters encountered. Path loss computation may be unreliable.')
                            end
                            loss = 30.18 + 8 + 26.0 * log10(MsBsDistance);
                    end


            end % end options for urban micro

        end

end     % end switch Scenario


% output
loss=loss(:);