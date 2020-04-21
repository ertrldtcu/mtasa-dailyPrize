-- işe yarar bi function
function iif(a,b,c)
	if a then return b else return c end
end

-- oyuncu hesaba girdiğinde
timers = {}
function loginFunc(_,acc)
	local today = getRealDateTimeString()
	local lastTime = getAccountData(acc,"lastTime")
	if today ~= lastTime then -- eğer hesapta son ödül alma günü bugün değilse
		if minute*60*1000 < 50 then -- eğer oynanması gereken dakika ms cinsinden 50'den küçükse direk işlemleri gerçekleştir.
			local prizeCount = getAccountData(acc,"prizeCount") or 0 -- oyuncunun kaç kere ödül aldığını çektik (yoksa 0)
			local weekCount = getAccountData(acc,"weekCount") or 0
			triggerClientEvent(source,"prizeSystem:sendPrizeToClient",source,prizes,prizeCount,weekCount) -- tabloyu ve oyuncunun ödül alma sayısını cliente yolladık
		return end
		outputChatBox("#999999Günlük ödülünü #00FF00"..minute.." #999999dakika sonra alacaksın :)",source,0,0,0,true)
		timers[source] = setTimer(function(pl,acc)
			local acc = getPlayerAccount(pl)
			if not isGuestAccount(acc) then
				local prizeCount = getAccountData(acc,"prizeCount") or 0 -- oyuncunun kaç kere ödül aldığını çektik (yoksa 0)
				local weekCount = getAccountData(acc,"weekCount") or 0
				triggerClientEvent(pl,"prizeSystem:sendPrizeToClient",pl,prizes,prizeCount,weekCount) -- tabloyu ve oyuncunun ödül alma sayısını cliente yolladık
			end
			timers[pl] = nil
		end,minute*60*1000,1,source,acc)
	end
end
addEvent("prizeSystem:onPlayerLogin",true)
addEventHandler("prizeSystem:onPlayerLogin",root,loginFunc)
addEventHandler("onPlayerLogin",root,loginFunc)

addEventHandler("onPlayerQuit",root,function()
	if isTimer(timers[source]) then
		killTimer(timers[source])
		timers[source] = nil
	end
end)

-- ödülü aldığını kaydet
function givePrize(oyuncu,hesap,kod,miktar,birim) -- ödülü veren fonksiyon
	if kod == "Para" then -- eğer hediye kodu Para ise
		givePlayerMoney(oyuncu,miktar)
	elseif kod == "Puan" then -- eğer hediye kodu Puan ise
		local puan = getAccountData(hesap,"points") or 0 -- oyuncunun hesaptaki puanını çektik
		setAccountData(hesap,"points",puan+miktar) -- oyuncunun puanına hediyeyi ekleyip hesaba kayıt ettik
	end
	outputChatBox("Günlük hediyeni aldın! +#00FF00"..miktar..birim,oyuncu,150,150,150,true)
end
addEvent("prizeSystem:givePrize",true)
addEventHandler("prizeSystem:givePrize",root,function(day)
	local acc = getPlayerAccount(source)
	if not isGuestAccount(acc) then
		local today = getRealDateTimeString()
		setAccountData(acc,"lastTime",today)
		setAccountData(acc,"prizeCount",iif(day==7,0,day))
		local week = getAccountData(acc,"weekCount") or 0
		if day == 7 then
			setAccountData(acc,"weekCount",week+1)
		end
		local tablo = prizes[day] -- o günün hediyesi
		givePrize(source,acc,tablo[1],tablo[2]+tablo[2]*(week/2),tablo[3])
	else
		outputChatBox("Hesabına giriş yapmadan günlük hediyeni alamazsın!",source,255,0,0,true)
	end
end)
-- bu fonksiyon kullanıldığı sıradaki yıl-ay-gün verir
function getRealDateTimeString()
	local time = getRealTime()
    return string.format( '%04d-%02x-%02d'
                        ,time.year + 1900
                        ,time.month + 1
                        ,time.monthday
                        )
end

-- bu kısmı boşver
setTimer(function()
	for i,pl in pairs(getElementsByType("player")) do
		local acc = getPlayerAccount(pl)
		if not isGuestAccount(acc) then
			triggerEvent("prizeSystem:onPlayerLogin",pl,1,acc)
		end
	end
end,1000,1)
