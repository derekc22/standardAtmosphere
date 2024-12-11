function [temperatureList, densityList, viscosityList, dataTable] = standardAtmosphere(heightList)

% STANDARDATMOSPHERE
% INPUT:  heightList - either a single height or a row vector of heights. Heights must be in meters 
% OUTPUT: temperatureList - the function returns the temperature at each height in heightList in the form of a row vector
%         densityList - the function returns the density at each height in heightList in the form of a row vector
%         viscosityList - the function returns the viscosity at each height in heightList in the form of a row vector
%         dataTable - the function formats heightList, temperatureList, densityList, and viscosityList into a MATLAB table object the function then exports dataTable to an Excel file 
% SAMPLE FUNCTION CALLS: 
% [temperatureList, densityList, viscosityList, dataTable] = standardAtmosphere(1000)
% [temperatureList, densityList, viscosityList, dataTable] = standardAtmosphere([5000, 12000, 20000])
% [temperatureList, densityList, viscosityList, dataTable] = standardAtmosphere(0:500:25000)


densitySL = 1.225;
temperatureSL = 288;

g = 9.81;
lapseRate = -0.0065;
gasConstant = 287;
temperature11 = temperatureSL + lapseRate*11000;
density11 = densitySL*(temperature11/temperatureSL)^-((g/(lapseRate*gasConstant))+1);

temperatureList = [];
densityList = [];
viscosityList = [];


for height = heightList

    % gradient region
    if height <= 11000
    
        temperature = temperatureSL + lapseRate*height;
    
        density = densitySL*(temperature/temperatureSL)^-((g/(lapseRate*gasConstant))+1);


    % isothermal region
    elseif height > 11000
        
        temperature = temperature11;
    
        density = density11*(exp(-g*((height-11000)/(287*temperature11))));
        
    end 


    temperatureList = [temperatureList, temperature];

    densityList = [densityList, density];

    viscosity = 1.54*(1+0.0039*(temperature-250))*(10^-5);
    viscosityList = [viscosityList, viscosity];

end

roundedTemperatureList = round(temperatureList, 3, "significant");
roundedDensityList = round(densityList, 3, "significant");
roundedViscosityList = round(viscosityList, 3, "significant");

format longG
dataArray = cat(2, heightList', roundedTemperatureList', roundedDensityList', roundedViscosityList');
dataTable  = array2table(dataArray,'VariableNames',{'h [m]','T [K]','ρ [kg/m^3]', 'μ [kg/m·s]'});

%recycle on
%filename = 'standardAtmosphereData.xlsx';
%delete(filename)
%writetable(dataTable,filename)

end 

