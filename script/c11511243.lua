--Dragonilian Link
function c11511243.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(11511243,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11511243.target)
	e1:SetOperation(c11511243.operation)
	c:RegisterEffect(e1)
end

function c11511243.filterP(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_PENDULUM)
end
function c11511243.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511243.filterP,tp,LOCATION_SZONE,0,1,nil)
				 and 	  Duel.IsExistingMatchingCard(c11511243.filterP,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11511243.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c11511243.filterP,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.GetLocationCount(tp,LOCATION_PZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11511243,0)) 
		then
		    Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end