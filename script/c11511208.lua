--Dragonilian Depthia
function c11511208.initial_effect(c)
	-- to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c11511208.sptg)
	e1:SetOperation(c11511208.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

end
function c11511208.filterD(c)
	return c:IsSetCard(0xffd) and c:IsAbleToDeck() 
	and Duel.IsExistingMatchingCard(c11511208.filterH,tp,LOCATION_DECK,0,1,nil,c)
end
function c11511208.filterH(c,tc)
	return c:IsSetCard(0xffd) and c:GetLevel()==tc:GetLevel() and not c:IsAttribute(tc:GetAttribute()) and c:IsAbleToHand()
end
function c11511208.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511208.filterD,tp,LOCATION_HAND,0,1,nil) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c11511208.filterD,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SEARCH+CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11511208.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,tp,nil,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11511208.filterH,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

