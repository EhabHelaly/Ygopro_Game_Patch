--Dragonilian Gyreth
function c11511204.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c11511204.target)
	e1:SetOperation(c11511204.operation)
	c:RegisterEffect(e1)
end

function c11511204.filterH(c)
	return c:IsSetCard(0xffd) and c:IsType(TYPE_MONSTER) and c:GetLevel()==4 and c:IsAbleToHand()
	and not Duel.IsExistingMatchingCard(Card.IsAttribute,c:GetControler(),LOCATION_MZONE,0,1, nil,c:GetAttribute())
end
function c11511204.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511204.filterH,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c11511204.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11511204.filterH,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
