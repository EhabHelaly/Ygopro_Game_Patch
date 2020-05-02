--Dragonilian Heart
function c11511239.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- Change Attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)	
	e2:SetTarget(c11511239.target)
	e2:SetOperation(c11511239.operation)
	c:RegisterEffect(e2)	
end
function c11511239.filter(c,e,tp,tc)
	return c:IsSetCard(0xffd) and c:IsFaceup()
end
function c11511239.target(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then return Duel.IsExistingTarget(c11511239.filter,tp,LOCATION_MZONE,0,1,nil) end	

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c11511239.filter,tp,LOCATION_MZONE,0,1,1,nil)	
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceAttribute(tp,1,0xffff-g:GetFirst():GetAttribute())
	e:SetLabel(rc)
	e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
end
function c11511239.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end