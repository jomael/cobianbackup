object CobBMService: TCobBMService
  OldCreateOrder = False
  DisplayName = 'Cobian Backup 8 service'
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
end
