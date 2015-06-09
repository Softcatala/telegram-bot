do

local users = {}

local AndroidLangPack = "strings.xml"
local iOSLangPack = "Localizable-ios.strings"
local WPLangPack = "wp.resx"
local TDLangPack = "tdesktop.strings"
local LangPackVersion = "25/05/2015"
local HelpMessage = "Si voleu catalanitzar el Telegram escriviu:\n «Android», «iOS» o «WP» (per WindowsPhone), segons el client i sistema operatiu que useu."
local DefaultMessage = "Hola, sóc un bot en pràctiques, no dono gaire conversa.\n"..HelpMessage
local AndroidMessage = "Instruccions d'instal·lació:\n1r. Baixeu el fitxer «strings.xml» enviat després d'aquest missatge fent clic a la icona de fletxa avall.\n2n. Feu clic al símbol ⋮ per a obrir el menú d'opcions.\n3r. Trieu «Apply localization file», «Aplicar traducción» o «Aplica la localització», segons el cas.\n4t. Trieu l'opció «Català»."
local iOSMessage = "Instruccions:\n1r. Baixeu el fitxer «Localizable-ios.strings» enviat.\n2n. Trieu «Apply localization file», «Aplicar traducción» o «Aplica la localització», segons el cas."
local WPMessage=  "Instruccions:\n1r. Baixeu el fitxer «wp.resx» enviat després d'aquest missatge.\n2n. Trieu «Apply localization file», «Aplicar traducción» o «Aplica la localització», segons el cas."
local TDMessage= "Intruccions d'instal·lació:\n1r. Baixeu el fitxer «tdesktop.strings» enviat després d'aquest missatge i recordeu la carpeta on es troba, habitualment './Baixades/Telegram Desktop' del vostre perfil d'usuari.\n2n. Aneu a la configuració del Telegram Desktop («Settings» o «Ajustes», secció «General») i pitgeu Maj+Alt+«Change language» (o Maj+Alt+«Canviar idioma»).\n3r. Trieu el fitxer «tdesktop.strings» baixat al pas 1.\n4t. Reinicieu el Telegram Desktop.\n\nImportant: aquest fitxer és experimental"

local ByeMessage= "Aquest bot us ajuda a catalanitzar el Telegram, però creiem que el català hauria d'estar inclòs per defecte al Telegram, atès que és trist haver de recórrer a mètodes alternatius per tenir el Telegram en la nostra llengua.\nSi també ho creieu, podeu ajudar fent clic a l'enllaç següent per a enviar una piulada al Twitter: http://ves.cat/merf"
  

local function add2log(string)
   local logFile = io.open("./data/catalanitzador.log", "a")
   
   io.output(logFile)
   io.write(string..'\n')
   
   io.close(logFile)   
end

local function run(msg, matches)

  local SupportedOS = false
  local SelectedOS = ''
  local file = ''
  local message = ''
  local match1 = string.lower(matches[1])
  
  local receiver = get_receiver(msg)   

  
  if users[receiver] and users[receiver] <= 3 then
     users[receiver] = users[receiver]+1
  else
    users[receiver] = 1
  end
  
  local UserNTries = users[receiver]

  
  if match1 == 'ajuda' or match1 == 'desperta' or match1== 'hola' then
     users[receiver] = 1
     return DefaultMessage
  elseif match1 =='android' then
     SupportedOS = true
     SelectedOS = 'Android'
     file = './data/catalanitzador/'.. AndroidLangPack
     message = AndroidMessage
  elseif match1 =='ios' then
     SupportedOS = true
     SelectedOS = 'iOS'
     file = './data/catalanitzador/'.. iOSLangPack
     message = iOSMessage
  elseif match1 =='wp' or match1 =='windowsphone' then
     SupportedOS = true
     SelectedOS = 'WP'
     file = './data/catalanitzador/'.. WPLangPack
     message = WPMessage
--  elseif match1 =='tdesktop' or match1 =='escriptori' then
--     SupportedOS = true
--     SelectedOS = 'tdesktop'
--     file = './data/catalanitzador/'.. TDLangPack
--     message = TDMessage
  else
     SupportedOS = false 
     SelectedOS = ''     
     file = ''
     message = DefaultMessage
  end
  
  if SupportedOS == true then
    local cb_extra = {file_path=file}
    local CurrentDate = os.date("%d/%m/%Y")     
    local InfoMessage = "Us enviem la versió "..LangPackVersion.." del paquet de llengua. Podeu demanar la versió més actual del paquet sempre que ho desitgeu."
    
    local logString = CurrentDate..';'..receiver..';'..LangPackVersion..';'..SelectedOS
    
    add2log(logString)
    
    send_document(receiver, file, ok_cb, false)

    send_large_msg(receiver, InfoMessage..'\n\n'..message..'\n\n'..ByeMessage)
--    send_large_msg(receiver, message)
--  send_large_msg(receiver, InfoMessage)
    
--    send_document(receiver, file, ok_cb, function (rec, ByeMessage) send_msg(rec, InfoMessage, ok_cb, false) end, receiver) 
--    send_large_msg(receiver,ByeMessage)
    users[receiver] = 0
    
  elseif UserNTries <= 1 then
    send_large_msg(receiver, DefaultMessage)
  elseif UserNTries == 2 then
    send_large_msg(receiver, HelpMessage)
  elseif UserNTries == 3 then
    send_large_msg(receiver, "M'avorriu. Si voleu res de mi, desperteu-me... 😴😴😴")
  elseif UserNTries == 4 then
    users[receiver] = 3    
  end
  
end

return {
  description = "Permet catalanitzar el client Telegram d'Android i iOS.", 
  usage = "[Android|iOS|WP|tdesktop]",
  patterns = {
    "^([a-zA-Z0-9]*)[ ]?.*$",
    "^(.*)$"
  }, 
  run = run 
}

end
