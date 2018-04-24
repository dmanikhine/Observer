unit uWeatherDataDisplays;

interface

uses uObserverPatternInterfaces, uWeatherData;

type

  TWeatherDataDisplay = class(TInterfacedObject, IObserver, IDisplay)
  private
    FSubject: TWeatherStation;
    FTemperature: integer;
    FHumidity: integer;
    FPressure: Double;
  public
    constructor Create(aWeatherData: TWeatherStation);
    destructor Destroy; override;
    procedure Update(aTemperature: integer; aHumidity: integer; aPressure: Double); virtual;
    procedure Display; virtual; abstract;
  end;

  TCurrentConditionsDisplay = class(TWeatherDataDisplay)
  public
    procedure Display; override;
  end;

  TStatisticsDisplay = class(TWeatherDataDisplay)
  private
    MaxTemp, MinTemp: integer;
    TempSum: integer;
    NumberOfTemps: integer;
  public
    constructor Create(aWeatherData: TWeatherStation);
    procedure Update(aTemperature: integer; aHumidity: integer; aPressure: Double); override;
    procedure Display; override;
  end;

  TForecastDisplay = class(TWeatherDataDisplay)
  private
    FPreviousPressure: Double;
  public
    procedure Update(aTemperature: integer; aHumidity: integer; aPressure: Double); override;
    procedure Display; override;
  end;

implementation

uses
      System.SysUtils
    ;

{ TCurrentConditionsDisplay }

procedure TCurrentConditionsDisplay.Display;
begin
  WriteLn('Current Conditions: ', FTemperature, 'F degrees, Humidity is ', FHumidity, ' and the pressure is ', FPressure, ' inches of mercury');
end;

{ TStatisticsDisplay }

constructor TStatisticsDisplay.Create(aWeatherData: TWeatherStation);
begin
  inherited Create(aWeatherData);
  NumberOfTemps := 1;
  FTemperature := 70;
  MaxTemp := FTemperature;
  MinTemp := FTemperature;
end;

procedure TStatisticsDisplay.Display;
begin
  WriteLn('Avg\Min\Max temperature is: ', Format('%f/%d/%d', [TempSum/NumberOfTemps, MinTemp, MaxTemp]));
end;

procedure TStatisticsDisplay.Update(aTemperature: integer; aHumidity: integer; aPressure: Double);
begin
  inherited Update(aTemperature, aHumidity, aPressure);
  Inc(NumberOfTemps);
  TempSum  := TempSum + aTemperature;

  if aTemperature >  MaxTemp then
  begin
    MaxTemp := aTemperature;
  end;

  if aTemperature < MinTemp then
  begin
    MinTemp := aTemperature;
  end;
end;

{ TForecastDisplay }


procedure TForecastDisplay.Display;
begin
  if (FPressure > FPreviousPressure) then
  begin
			Writeln('Improving weather on the way!');
  end else
  begin
     if (FPressure = FPreviousPressure) then
     begin
       WriteLn('More of the same');
     end else
     begin
       WriteLn('Watch out for cooler, rainy weather');
     end;
  end;
end;

procedure TForecastDisplay.Update(aTemperature: integer; aHumidity: integer; aPressure: Double);
begin
  FPreviousPressure := FPressure;
  inherited Update(aTemperature, aHumidity, aPressure);
end;

{ TWeatherDataDisplay }

constructor TWeatherDataDisplay.Create(aWeatherData: TWeatherStation);
begin
  inherited Create;
  FSubject := aWeatherData;
  FSubject.RegisterObserver(Self);
end;

destructor TWeatherDataDisplay.Destroy;
begin
  FSubject := nil;
  inherited;
end;

procedure TWeatherDataDisplay.Update(aTemperature, aHumidity: integer; aPressure: Double);
begin
  FTemperature := aTemperature;
  FHumidity := aHumidity;
  FPressure := aPressure;
  Display;
end;

end.
