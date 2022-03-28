unit HelpNdocException;

interface
uses Classes, SysUtils;

type
  NoErrorException    = class(Exception);
  yyErrorException    = class(Exception);

  EofCheckException   = class(Exception);

  SaveDialogException = class(Exception);
  LoadDialogException = class(Exception);

  procedure yyerror(s: string);
implementation

procedure yyerror(s: string);
begin
  raise yyErrorException.Create(s);
end;

end.
