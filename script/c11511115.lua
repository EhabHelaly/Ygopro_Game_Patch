--Beast Rebirth
function c11511115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c11511115.cost)
	e1:SetOperation(c11511115.activate)
	c:RegisterEffect(e1)
end
function c11511115.filter1(c,tp)
	return c:IsSetCard(0xffe) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_XYZ)
	and Duel.IsExistingTarget(c11511115.filter2,tp,LOCATION_GRAVE,0,1,nil,c:GetRace())
end
function c11511115.filter2(c,rc)
	return c:IsSetCard(0xffe) and c:IsAbleToHand() and c:IsRace(rc)
end
function c11511115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511115.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11511115.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
    Duel.SendtoGrave(g,nil,0,REASON_COST)
    e:SetLabelObject(g:GetFirst())
end
function c11511115.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectTarget(tp,c11511115.filter2,tp,LOCATION_GRAVE,0,1,1,tc,tc:GetRace())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
