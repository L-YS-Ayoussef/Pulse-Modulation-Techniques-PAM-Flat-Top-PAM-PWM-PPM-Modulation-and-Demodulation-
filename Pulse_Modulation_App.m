classdef PulseModulationApp < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        GridLayout           matlab.ui.container.GridLayout
        RightPanel           matlab.ui.container.Panel
        OutputAxes           matlab.ui.control.UIAxes
        ModulateButton       matlab.ui.control.Button
        ModulationDropDown   matlab.ui.control.DropDown
        TEditField           matlab.ui.control.NumericEditField
        AEditField           matlab.ui.control.NumericEditField
        TsEditField          matlab.ui.control.NumericEditField
        EnterTVectorEditField matlab.ui.control.EditField
        EnterMVectorEditField matlab.ui.control.EditField
        TLabel               matlab.ui.control.Label
        ALabel               matlab.ui.control.Label
        TsLabel              matlab.ui.control.Label
        TVectorLabel         matlab.ui.control.Label
        MVectorLabel         matlab.ui.control.Label
    end

    methods (Access = private)
        
        function results = modulateSignal(app, t, m)
            % Retrieve modulation parameters
            Ts = app.TsEditField.Value;
            T = app.TEditField.Value;
            A = app.AEditField.Value;
            modulationType = app.ModulationDropDown.Value;
            
            % Define modulation function here based on 'modulationType'
            % Placeholder: actual modulation function to be implemented
            results = m; % Modify this line with actual modulation algorithm
        end
        
    end

    % App initialization and construction
    methods (Access = private)
        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 360];
            app.UIFigure.Name = 'Pulse Modulation App';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x'};
            app.GridLayout.RowHeight = {'1x'};
            
            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 1;

            % Create ModulateButton
            app.ModulateButton = uibutton(app.RightPanel, 'push');
            app.ModulateButton.Text = 'Modulate';
            app.ModulateButton.Position = [520 50 100 22];
            app.ModulateButton.ButtonPushedFcn = @(btn,event) modulateAndPlot(app);   

            % Create DropDown for Modulation Type
            app.ModulationDropDown = uidropdown(app.RightPanel);
            app.ModulationDropDown.Items = {'PAM', 'Flat-top PAM', 'PWM', 'PPM'};
            app.ModulationDropDown.Position = [20 20 100 22];
            app.ModulationDropDown.ValueChangedFcn = @(dropdown,event) updateEditFields(app);

            

            % Create EditField for T
            app.TEditField = uieditfield(app.RightPanel, 'numeric');
            app.TEditField.Position = [130 20 50 22];

            % Create EditField for A
            app.AEditField = uieditfield(app.RightPanel, 'numeric');
            app.AEditField.Position = [190 20 50 22];
            app.AEditField.Visible = 'off';

            % Create EditField for Ts
            app.TsEditField = uieditfield(app.RightPanel, 'numeric');
            app.TsEditField.Position = [250 20 50 22];
            
            % Create EditField for t vector
            app.EnterTVectorEditField = uieditfield(app.RightPanel, 'text');
            app.EnterTVectorEditField.Position = [310 60 200 22];
            
            % Create EditField for m vector
            app.EnterMVectorEditField = uieditfield(app.RightPanel, 'text');
            app.EnterMVectorEditField.Position = [310 20 200 22];
            
            % Create Labels
            app.TLabel = uilabel(app.RightPanel);
            app.TLabel.Position = [130 40 25 22];
            app.TLabel.Text = 'T:';
            
            app.ALabel = uilabel(app.RightPanel);
            app.ALabel.Position = [190 40 25 22];
            app.ALabel.Text = 'A:';
            app.ALabel.Visible = 'off';
            
            app.TsLabel = uilabel(app.RightPanel);
            app.TsLabel.Position = [250 40 25 22];
            app.TsLabel.Text = 'Ts:';
            
            app.TVectorLabel = uilabel(app.RightPanel);
            app.TVectorLabel.Position = [310 80 100 22];
            app.TVectorLabel.Text = 'Enter t vector:';
            
            app.MVectorLabel = uilabel(app.RightPanel);
            app.MVectorLabel.Position = [310 40 100 22];
            app.MVectorLabel.Text = 'Enter m vector:';

            % Show the UIFigure after all components are created
            app.UIFigure.Visible = 'on';
        end

        % Function to update visibility of edit fields based on selected modulation type
        function updateEditFields(app)
            selectedModulation = app.ModulationDropDown.Value;
            switch selectedModulation
                case 'PPM'
                    app.TEditField.Visible = 'on';
                    app.TLabel.Visible = 'on';
                    app.AEditField.Visible = 'on';
                    app.ALabel.Visible = 'on';
                case {'PAM', 'Flat-top PAM'}
                    app.TEditField.Visible = 'on';
                    app.TLabel.Visible = 'on';
                    app.AEditField.Visible = 'off';
                    app.ALabel.Visible = 'off';
                case 'PWM'
                    app.AEditField.Visible = 'on';
                    app.ALabel.Visible = 'on';
                    app.TEditField.Visible = 'off';
                    app.TLabel.Visible = 'off';
            end
        end
    end

    methods (Access = public)
        % Construct app
        function app = PulseModulationApp
            % Create and configure components
            createComponents(app)
            % Register the app with App Designer
            registerApp(app, app.UIFigure)
            if nargout == 0
                clear app
            end
        end
        
        % Define modulateAndPlot function
        function modulateAndPlot(app)
            t = str2double(strsplit(app.EnterTVectorEditField.Value, '	'));
            m = str2double(strsplit(app.EnterMVectorEditField.Value, '	'));
            Ts = app.TsEditField.Value;
            T = app.TEditField.Value;
            A = app.AEditField.Value;
            modulationType = app.ModulationDropDown.Value;
            
            if strcmp(modulationType, 'PPM')
                duty_cycle = T;
                sawth = A .* sawtooth(2 * pi * 1 / Ts * t, duty_cycle); 
                [m, p, modulatedSignal, demodulatedSignal] = modulationFunctions(t, m, Ts, T, A, modulationType, sawth);
            else
                sawth = A .* sawtooth(2 * pi * 1 / Ts * t); % Only for PWM and PPM
                [m, p, modulatedSignal, demodulatedSignal] = modulationFunctions(t, m, Ts, T, A, modulationType, sawth);
            end
            
            if(length(demodulatedSignal) ~= length(t))
                x = floor((length(demodulatedSignal) - length(t))/2);
                demodulatedSignal = demodulatedSignal(x:length(demodulatedSignal)-x-1);
            end
            
            % Plot results in four subplots
            figure;
            subplot(4,1,1, 'Parent', app.OutputAxes);
            plot(t, m, 'b');
            title('Message Signal m(t)');
            
            subplot(4,1,2, 'Parent', app.OutputAxes);
            plot(t, p, 'r');
            title('Carrier Signal p(t)');
            
            subplot(4,1,3, 'Parent', app.OutputAxes);
            plot(t, modulatedSignal, 'g');
            title('Modulated Signal');
            
            subplot(4,1,4, 'Parent', app.OutputAxes);
            plot(t, demodulatedSignal, 'k');
            title('Demodulated Signal');
%             drawnow;
%             saveas(gcf, "C:\Users\ABC 2022\Documents\testCase3_PAM_flatTop.fig");

        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
