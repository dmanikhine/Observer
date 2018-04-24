unit uWeatherData;

interface

uses    uObserverPatternInterfaces
      , Generics.Collections
      ;

type
  TWeatherStation = class(TInterfacedObject, ISubject)
  private
    FTemperature: integer;
    FHumidity: integer;
    FPressure: double;
    FObserverList: TList<IObserver>;
    function GetTemperature: integer;
    function GetHumidity: integer;
    function GetPressure: double;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetWeatherInformation(aTemperature: integer; aHumidity: integer; aPressure: double);
    procedure RegisterObserver(aObserver: IObserver);
    procedure RemoveObserver(aObserver: IObserver);
    procedure NotifyObservers;
    procedure MeasurementsChanged;
    property Temperature: integer read GetTemperature;
    property Humidity: integer read GetHumidity;
    property Pressure: double read GetPressure;
  end;

implementation

{ TWeatherData }

constructor TWeatherStation.Create;
begin
  inherited Create;
  FObserverList := TList<IObserver>.Create;
end;

destructor TWeatherStation.Destroy;
begin
  FObserverList.Free;
  inherited;
end;

function TWeatherStation.GetHumidity: integer;
begin
  Result := FHumidity;
end;

function TWeatherStation.GetPressure: double;
begin
  Result := FPressure;
end;

function TWeatherStation.GetTemperature: integer;
begin
  Result := FTemperature;
end;

procedure TWeatherStation.MeasurementsChanged;
begin
  NotifyObservers;
end;

procedure TWeatherStation.NotifyObservers;
var
  Observer: IObserver;
begin
  for Observer in FObserverList do
  begin
    Observer.Update(Temperature, Humidity, Pressure);
  end;
end;

procedure TWeatherStation.RegisterObserver(aObserver: IObserver);
begin
  FObserverList.Add(aObserver);
end;

procedure TWeatherStation.RemoveObserver(aObserver: IObserver);
begin
  FObserverList.Remove(aObserver);
end;

procedure TWeatherStation.SetWeatherInformation(aTemperature, aHumidity: integer; aPressure: double);
begin
  FTemperature := aTemperature;
  FHumidity := aHumidity;
  FPressure := aPressure;
  MeasurementsChanged;
end;

end.
