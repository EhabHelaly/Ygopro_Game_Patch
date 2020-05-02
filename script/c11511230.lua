--Dragonilian Reusnous
function c11511230.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(c11511230.filterS,ATTRIBUTE_FIRE),aux.NonTuner(c11511230.filterS,ATTRIBUTE_LIGHT))
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(c11511230.filterS,ATTRIBUTE_LIGHT),aux.NonTuner(c11511230.filterS,ATTRIBUTE_FIRE))
	-- add pendulum to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c11511230.target)
	e1:SetOperation(c11511230.operation)
	c:RegisterEffect(e1)

end
function c11511230.filterS(c,att)
	return c:IsSetCard(0xffd) and c:IsAttribute(att) 
end
function c11511230.filter(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c11511230.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511230.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c11511230.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11511230.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
