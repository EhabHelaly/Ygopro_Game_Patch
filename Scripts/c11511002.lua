--Elegantea Defender Alborin
function c11511002.initial_effect(c)
    -- lv change
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetDescription(aux.Stringid(11511002,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11511002.limcon)
	e1:SetTarget(c11511002.targetM)
	e1:SetOperation(c11511002.operationM)
	c:RegisterEffect(e1)
    --synchro , xyz limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c11511002.limit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)

	--Battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c11511002.tg)
	e4:SetCountLimit(1)
	e4:SetValue(c11511002.valcon)
	c:RegisterEffect(e4)
end
function c11511002.tg(e,c)
	return c:IsSetCard(0xff)
end
function c11511002.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c11511002.filterlim(c)
	return c:IsCode(11511045) and c:IsFaceup() and not c:IsDisabled()
end
function c11511002.limcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    if Duel.IsExistingMatchingCard(c11511002.filterlim,tp,LOCATION_SZONE,0,1,nil)
    then return e:GetHandler():GetFlagEffect(11511002)<2
	else return e:GetHandler():GetFlagEffect(11511002)<1 end
end
function c11511002.limit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xff)
end
function c11511002.filterM1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xff) and c:GetLevel()>0 and Duel.IsExistingTarget(c11511002.filterM2,tp,LOCATION_MZONE,0,1,c)
end
function c11511002.filterM2(c)
	return c:IsFaceup() and c:IsSetCard(0xff) and c:GetLevel()>1
end
function c11511002.targetM(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11511002.filterM1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11511002.filterM1,tp,LOCATION_MZONE,0,1,nil,tp)  end
         Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11511002,1))
         local g1=Duel.SelectTarget(tp,c11511002.filterM1,tp,LOCATION_MZONE,0,1,1,nil,tp)
         e:SetLabelObject(g1:GetFirst())
         Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11511002,2))
         local g2=Duel.SelectTarget(tp,c11511002.filterM2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
    	 e:GetHandler():RegisterFlagEffect(11511002,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
 end
function c11511002.operationM(e,tp,eg,ep,ev,re,r,rp)
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