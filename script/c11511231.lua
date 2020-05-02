--Dragonilian Zarkish
function c11511231.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c11511231.filterS,ATTRIBUTE_DARK),1,1,aux.NonTuner(c11511231.filterS,ATTRIBUTE_EARTH),1,1)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c11511231.filterS,ATTRIBUTE_EARTH),1,1,aux.NonTuner(c11511231.filterS,ATTRIBUTE_DARK),1,1)
	-- add attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c11511231.target)
	e1:SetOperation(c11511231.operation)
	c:RegisterEffect(e1)

end
function c11511231.filterS(c,att)
	return c:IsSetCard(0xffd) and c:IsAttribute(att) 
end
function c11511231.filter(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
	and c:GetAttribute()~=ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_WIND+ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_DEVINE
end
function c11511231.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511231.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11511231.filter,tp,LOCATION_MZONE,0,1,1,nil)	
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local att=Duel.AnnounceAttribute(tp,1,0xffff-g:GetFirst():GetAttribute())
	e:SetLabel(att)
end
function c11511231.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local att=e:GetLabel()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
