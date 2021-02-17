unit Interfaces.Controllers;

interface

uses Horse;

Type
  IControllers = interface
  ['{1A39C804-DEE3-4139-8CEB-C5D3D2EF442C}']
  procedure Index;
  procedure IndexById;
  procedure Insert;
  procedure Update;
  procedure Delete;

  end;

implementation

end.
