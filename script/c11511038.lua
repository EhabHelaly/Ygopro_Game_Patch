--Elegantea Lineup
function c11511038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11511038)
	e1:SetTarget(c11511038.target)
	e1:SetOperation(c11511038.activate)
	c:RegisterEffect(e1)
end
function c11511038.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)and c:GetLevel()~=c:GetOriginalLevel()
end
function c11511038.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)
end
function c11511038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11511038.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11511038.filter,tp,LOCATION_MZONE,0,1,nil)
                      and Duel.IsExistingTarget(c11511038.filte2,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c11511038.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11511038.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c11511038.filter2,tp,LOCATION_MZONE,0,tc)
		local lc=g:GetFirst()
		local lv=tc:GetLevel()
		while lc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			lc:RegisterEffect(e1)
			lc=g:GetNext()
		end
	end
end
