--Furious Return
function c11511114.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11511114.target)
	e1:SetOperation(c11511114.activate)
	c:RegisterEffect(e1)
end
function c11511114.filter1(c)
	return c:IsSetCard(0xfe) and c:IsAbleToDeck() and Duel.IsExistingTarget(c11511114.filter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,c)
end
function c11511114.filter2(c)
	return c:IsSetCard(0xfe) and c:IsAbleToGrave()
end
function c11511114.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511114.filter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c11511114.filter1,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c11511114.filter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,g1:GetFirst())
    e:SetLabelObject(g1:GetFirst())
end
function c11511114.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	if not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e) then return end
		Duel.SendtoDeck(tc1,nil,0,REASON_EFFECT)
		Duel.SendtoGrave(tc2,nil,0,REASON_EFFECT)
end