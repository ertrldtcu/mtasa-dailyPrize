prizes = {}
addEvent("prizeSystem:sendPrizeToClient",true)
addEventHandler("prizeSystem:sendPrizeToClient",root,function(tablo,count,wek)
	prizes = tablo
	current = count+1
	weekCount = wek
	addEventHandler("onClientRender",root,renderFunction)
	addEventHandler("onClientClick",root,clickFunction)
end)
function iif(a,b,c)
	if a then return b else return c end
end
sx,sy = guiGetScreenSize()
pw = sx/2
px = (sx-pw)/2
mw,mh = (pw-50)/4,(pw-50)/4
ph = mh*2+30
py = (sy-ph)/2
imgTick = getTickCount()
currentIMG = 1
function renderFunction()
	local now = getTickCount()
	--background
	dxDrawRectangle(px,py,pw,ph-1,tocolor(0,0,0,150),true)
	dxDrawRectangle(px+2,py-2,pw-4,2,tocolor(0,0,0,150),true)
	dxDrawRectangle(px-2,py+2,2,ph-5,tocolor(0,0,0,150),true)
	dxDrawRectangle(px+pw,py+2,2,ph-5,tocolor(0,0,0,150),true)
	dxDrawRectangle(px+2,py+ph-1,pw-4,2,tocolor(0,0,0,150),true)
	
	for day,t in pairs(prizes) do
		-- calculate size and pos
		local posX,posY = px+10*(iif(day-3>0,day-3,day))+mw*(iif(day-3>0,day-3,day)-1),py+10*(iif(day-3>0,2,1))+mh*(iif(day-3>0,1,0))
		local ih = mh
		local posY,mh = iif(day==7,py+10,posY),iif(day==7,mh*2+10,mh)
		-- back
		dxDrawRectangle(posX,posY,mw,mh,iif(day<current,tocolor(150,255,150,70)) or iif(day==current,tocolor(150,150,255,70)) or tocolor(150,150,150,50),true)
		dxDrawRectangle(posX+2,posY-2,mw-4,2,iif(day<current,tocolor(150,255,150,70)) or iif(day==current,tocolor(150,150,255,70)) or tocolor(150,150,150,50),true)
		dxDrawRectangle(posX-2,posY+2,2,mh-4,iif(day<current,tocolor(150,255,150,70)) or iif(day==current,tocolor(150,150,255,70)) or tocolor(150,150,150,50),true)
		dxDrawRectangle(posX+mw,posY+2,2,mh-4,iif(day<current,tocolor(150,255,150,70)) or iif(day==current,tocolor(150,150,255,70)) or tocolor(150,150,150,50),true)
		dxDrawRectangle(posX+2,posY+mh,mw-4,1,iif(day<current,tocolor(150,255,150,70)) or iif(day==current,tocolor(150,150,255,70)) or tocolor(150,150,150,50),true)
		-- o arkadaki parıltı
		if day == current then
			dxDrawImage(posX,posY+iif(mh~=ih,mh/4,0),ih,ih,"earn.png",(math.cos(now/1000)*10),0,0,nil,true) --tocolor(255,255,255,125+(math.sin(now/250)*125))
		end
		-- title
		dxDrawRectangle(posX,posY,mw,ih/5,iif(day<current,tocolor(150,255,150,70)) or iif(day==current,tocolor(150,150,255,70)) or tocolor(150,150,150,50),true)
		dxDrawRectangle(posX+2,posY-2,mw-4,2,iif(day<current,tocolor(150,255,150,70)) or iif(day==current,tocolor(150,150,255,70)) or tocolor(150,150,150,50),true)
		dxDrawRectangle(posX-2,posY+2,2,ih/5-2,iif(day<current,tocolor(150,255,150,70)) or iif(day==current,tocolor(150,150,255,70)) or tocolor(150,150,150,50),true)
		dxDrawRectangle(posX+mw,posY+2,2,ih/5-2,iif(day<current,tocolor(150,255,150,70)) or iif(day==current,tocolor(150,150,255,70)) or tocolor(150,150,150,50),true)
		-- texts
		dxDrawText(day..". Gün",posX,posY,posX+mw,posY+ih/5,color,nil,"default-bold","center","center",nil,nil,true)
		dxDrawText((t[2]+t[2]*(weekCount/2))..t[3]..iif(day==current,"\nALMAK İÇİN TIKLA",""),posX,posY+4*mh/5,posX+mw,posY+mh,color,nil,"default-bold","center","center",nil,nil,true)
		-- img
		if now >= imgTick+30 then
			currentIMG = iif(currentIMG==16,1,currentIMG+1)
			imgTick = now
		end
		dxDrawImage(posX+.6*ih/2,posY+mh/2-(ih/2.5)/2,ih/2.5,ih/2.5,iif(t[1]=="Para","coin","exp").."/"..iif(day==current or isMouseInPosition (posX,posY,mw,mh),currentIMG,1)..".png",0,0,0,nil,true)
	end
end

function isMouseInPosition(x,y,width,height)
	if (not isCursorShowing()) then
		return false
	end
	local sx,sy = guiGetScreenSize()
	local cx,cy = getCursorPosition()
	local cx,cy = (cx*sx),(cy*sy)
	if (cx>=x and cx<=x+width) and (cy>=y and cy<=y+height) then
		return true
	else
		return false
	end
end

function clickFunction(btn,st)
	if btn == "left" and st == "up" then
		local posX = px+10*(iif(current-3>0,current-3,current))+mw*(iif(current-3>0,current-3,current)-1)
		local posY = py+10*(iif(current-3>0,2,1))+mh*(iif(current-3>0,1,0))
		local mh = iif(current==7,mh*2+10,mh)
		local posY = iif(current==7,py+10,posY)
		if isMouseInPosition(posX,posY,mw,mh) then
			removeEventHandler("onClientRender",root,renderFunction)
			triggerServerEvent("prizeSystem:givePrize",localPlayer,current)
			removeEventHandler("onClientClick",root,clickFunction)
		end
	end
end