--Elegantea Hero Crudan
function c11511010.initial_effect(c)
    c:EnableCounterPermit(0xff)
	c:SetCounterLimit(0xff,3)
    -- lv change
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetDescription(aux.Stringid(11511010,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11511010.limcon)
	e1:SetTarget(c11511010.targetM)
	e1:SetOperation(c11511010.operationM)
	c:RegisterEffect(e1)
    --synchro , xyz limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c11511010.limit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	--add counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED+LOCATION_OVERLAY)
	e4:SetCondition(c11511010.condition)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c11511010.Ecount)
	c:RegisterEffect(e5)
	e4:SetLabelObject(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(11511010,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c11511010.spcost)
	e6:SetTarget(c11511010.sptg)
	e6:SetOperation(c11511010.spop)
	c:RegisterEffect(e6)
end
function c11511010.cfilter(c,s)
	return c:GetLevel()>0 and c:IsFaceup() and c:IsSetCard(0xff) and c:GetSequence()==s
end
function c11511010.condition(e,tp,eg,ep,ev,re,r,rp)
	local x="00"
	local y="0000000000"
	for seq=0,4 do
        if Duel.CheckLocation(tp,LOCATION_MZONE,seq) or not e:GetHandler():IsFaceup() then x="00" else
            local g=Duel.GetMatchingGroup(c11511010.cfilter,tp,LOCATION_MZONE,0,nil,seq)
            if g:GetCount()>0 then
                local tc=g:GetFirst()
                local lv=tc:GetLevel()
                if lv<10 then x="0"..tostring(lv) else x=tostring(lv) end
            else  x="00"
            end
        end
    if seq==0 then y=x else y=y..x end
    end
    e:GetLabelObject():SetLabel(tonumber(y))
    return true
end
function c11511010.Ecount(e,tp,eg,ep,ev,re,r,rp)
	local y=tostring(e:GetLabel())
	while string.len(y)<10 do
        y="0"..y
	end
    for seq=0,4 do
        local g=Duel.GetMatchingGroup(c11511010.cfilter,tp,LOCATION_MZONE,0,nil,seq)
        if g:GetCount()>0 then
            local tc=g:GetFirst()
            local lv=tc:GetLevel()
            local x=string.sub(y,2*seq+1,2*seq+2)
            if ( lv~=tonumber(x) and tonumber(x)~=0 )
            then e:GetHandler():AddCounter(0xff,1)
                 break
            end
        end
    end
end
function c11511010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xff,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xff,3,REASON_COST)
end
function c11511010.spfilter(c,e,tp)
	return c:IsSetCard(0xff) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not c:IsCode(11511010) and c:GetLevel()>0
end
function c11511010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11511010.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function c11511010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11511010.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11511010.filterlim(c)
	return c:IsCode(11511045) and c:IsFaceup() and not c:IsDisabled()
end
function c11511010.limcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    if Duel.IsExistingMatchingCard(c11511010.filterlim,tp,LOCATION_SZONE,0,1,nil)
    then return e:GetHandler():GetFlagEffect(11511010)<2
	else return e:GetHandler():GetFlagEffect(11511010)<1 end
end
function c11511010.limit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xff)
end
function c11511010.filterM1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xff) and c:GetLevel()>0 and Duel.IsExistingTarget(c11511010.filterM2,tp,LOCATION_MZONE,0,1,c)
end
function c11511010.filterM2(c)
	return c:IsFaceup() and c:IsSetCard(0xff) and c:GetLevel()>1
end
function c11511010.targetM(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11511010.filterM1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11511010.filterM1,tp,LOCATION_MZONE,0,1,nil,tp)  end
         Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11511010,1))
         local g1=Duel.SelectTarget(tp,c11511010.filterM1,tp,LOCATION_MZONE,0,1,1,nil,tp)
         e:SetLabelObject(g1:GetFirst())
         Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11511010,2))
         local g2=Duel.SelectTarget(tp,c11511010.filterM2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
    	 e:GetHandler():RegisterFlagEffect(11511010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
 end
function c11511010.operationM(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(1)
		if hc:RegisterEffect(e1) then
			local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetCode(EFFECT_UPDATE_LEVEL)
            e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(-1)
            tc:RegisterEffect(e2)
		end
	end
end
