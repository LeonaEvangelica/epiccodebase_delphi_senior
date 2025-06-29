unit uTestOrdemServico;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TestOrdemServico = class
  public
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TestOrdemServico.Test1;
begin
end;

procedure TestOrdemServico.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TestOrdemServico);

end.
