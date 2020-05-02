--Elegantea Vampire Zadicus
function c11511024.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfff),aux.NonTuner(Card.IsSetCard,0xfff),1)
	c:EnableReviveLimit()
    -- lv change
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetDescription(aux.Stringid(11511024,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11511024.limcon)
	e1:SetTarget(c11511024.targetM)
	e1:SetOperation(c11511024.operationM)
	c:RegisterEffect(e1)
	--xyz material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCondition(c11511024.efcon)
	e2:SetCountLimit(1,11511024)
	e2:SetOperation(c11511024.efop)
	c:RegisterEffect(e2)
end
function c11511024.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c11511024.efop(e,tp,eg,ep,ev,re,r,rp)
	--sp summon
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(11511024,3))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11511024.spcon)
	e1:SetTarget(c11511024.tg)
	e1:SetOperation(c11511024.spop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c11511024.filter(c,e,tp)
	return  c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11511024.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c11511024.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  e:GetHandler():GetOverlayGroup():IsExists(c11511024.filter,1,nil,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  end
end
function c11511024.spop(e,tp,eg,ep,ev,re,r,rp)
 		local g1=e:GetHandler():GetOverlayGroup()
		local g2=g1.Filter(g1,c11511024.filter,nil,e,tp)
		local g=g2:Select(tp,1,1,nil)
        if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
end
function c11511024.filterlim(c)
	return c:IsCode(11511045) and c:IsFaceup() and not c:IsDisabled()
end
function c11511024.limcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    if Duel.IsExistingMatchingCard(c11511024.filterlim,tp,LOCATION_SZONE,0,1,nil)
    then return e:GetHandler():GetFlagEffect(11511024)<2
	else return e:GetHandler():GetFlagEffect(11511024)<1 end
end
function c11511024.limit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xfff)
end
function c11511024.filterM1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfff) and c:GetLevel()>0 and Duel.IsExistingTarget(c11511024.filterM2,tp,LOCATION_MZONE,0,1,c)
end
function c11511024.filterM2(c)
	return c:IsFaceup() and c:IsSetCard(0xfff) and c:GetLevel()>1
end
function c11511024.targetM(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11511024.filterM1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11511024.filterM1,tp,LOCATION_MZONE,0,1,nil,tp)  end
         Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11511024,1))
         local g1=Duel.SelectTarget(tp,c11511024.filterM1,tp,LOCATION_MZONE,0,1,1,nil,tp)
         e:SetLabelObject(g1:GetFirst())
         Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11511024,2))
         local g2=Duel.SelectTarget(tp,c11511024.filterM2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
    	 e:GetHandler():RegisterFlagEffect(11511024,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
 end
function c11511024.operationM(e,tp,eg,ep,ev,re,r,rp)
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
