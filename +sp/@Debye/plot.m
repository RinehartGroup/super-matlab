function plot(obj, plot_type, varargin)
    if isempty(obj.model_data)
        warning('data is not fit');
    else
        group = obj.model_data.TemperatureRounded;
        switch plot_type
            case 'in'
                xmodel = obj.model_data.Frequency;
                ymodel = obj.model_data.ChiIn;
            case 'out'
                xmodel = obj.model_data.Frequency;
                ymodel = obj.model_data.ChiOut;
            case 'cole'
                xmodel = obj.model_data.ChiIn;
                ymodel = obj.model_data.ChiOut;
            case 'arrhenius'
                columns = obj.fits(:, contains(obj.fits.Properties.VariableNames, 'tau'));
                group = repmat(obj.fits.TemperatureRounded, 1, width(columns));
                
                xmodel = 1 ./ obj.fits.TemperatureRounded;
                xmodel = repmat(xmodel, width(columns), 1);
                ymodel = log(reshape(table2array(columns), [height(obj.fits)*width(columns), 1]));
                
                sp.PlotHelper.scatter(xmodel, ymodel, group, 'd');
                return
            otherwise
                error('unsupported plot type');
        end
        
        sp.PlotHelper.plot(xmodel, ymodel, group);
    end
    
    for a = 1:length(obj.datafiles)
        obj.datafiles(a).plot(plot_type, varargin{:});
    end
    sp.PlotHelper.set_impedence_axes(plot_type);
    sp.PlotHelper.set_color();
end