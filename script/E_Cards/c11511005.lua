--Elegantea Guardian Brifius
local s,id=GetID()
function s.initial_effect(c)
    -- lv change
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.limcon)
	e1:SetTarget(s.targetM)
	e1:SetOperation(s.operationM)
	c:RegisterEffect(e1)
    --synchro , xyz limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(s.limit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(2,id+EFFECT_COUNT_CODE_DUEL)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff) and c:IsType(TYPE_XYZ)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function s.filterlim(c)
	return c:IsCode(11511045) and c:IsFaceup() and not c:IsDisabled()
end
function s.limcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    if Duel.IsExistingMatchingCard(s.filterlim,tp,LOCATION_SZONE,0,1,nil)
    then return e:GetHandler():GetFlagEffect(id)<2
	else return e:GetHandler():GetFlagEffect(id)<1 end
end
function s.limit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xfff)
end
function s.filterM1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfff) and c:GetLevel()>0 and Duel.IsExistingTarget(s.filterM2,tp,LOCATION_MZONE,0,1,c)
end
function s.filterM2(c)
	return c:IsFaceup() and c:IsSetCard(0xfff) and c:GetLevel()>1
end
function s.targetM(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filterM1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filterM1,tp,LOCATION_MZONE,0,1,nil,tp)  end
         Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
         local g1=Duel.SelectTarget(tp,s.filterM1,tp,LOCATION_MZONE,0,1,1,nil,tp)
         e:SetLabelObject(g1:GetFirst())
         Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
         local g2=Duel.SelectTarget(tp,s.filterM2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
    	 e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
 end
function s.operationM(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(1)
		if hc:RegisterEffect(e1) then
			local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetCode(EFFECT_UPDATE_LEVEL)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(-1)
            tc:RegisterEffect(e2)
		end
	end
end
