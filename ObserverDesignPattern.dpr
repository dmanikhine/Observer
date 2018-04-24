program ObserverDesignPattern;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uWeatherData in 'uWeatherData.pas',
  uBehaviorInterfaces in 'uBehaviorInterfaces.pas',
  uObserverPatternInterfaces in 'uObserverPatternInterfaces.pas',
  uWeatherDataDisplays in 'uWeatherDataDisplays.pas';

procedure DoWeatherStation;
var
  WeatherStation: TWeatherStation;
  CurrentDisplay: IDisplay;
  ForecastDisplay: IDisplay;
  StatsDisplay: IDisplay;
begin
  WeatherStation := TWeatherStation.Create;
  try
    CurrentDisplay := TCurrentConditionsDisplay.Create(WeatherStation);
    ForecastDisplay := TForecastDisplay.Create(WeatherStation);
    StatsDisplay := TStatisticsDisplay.Create(WeatherStation);;
    WeatherStation.SetWeatherInformation(70, 55, 28.90);
    WeatherStation.SetWeatherInformation(68, 59, 28.96);
    WeatherStation.SetWeatherInformation(35, 66, 27.40);
    WeatherStation.SetWeatherInformation(55, 55, 27.40);

  finally
    WeatherStation.Free;
  end;
end;

begin
  try
    DoWeatherStation;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.
