--Bringer Of Peace
function c11511454.initial_effect(c)
	-- add to hand (monster)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11511454.tg1)
	e1:SetOperation(c11511454.op1)
	c:RegisterEffect(e1)
	-- return to hand (monster)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c11511454.cost2)
	e2:SetTarget(c11511454.tg2)
	e2:SetOperation(c11511454.op2)
	c:RegisterEffect(e2)
end
function c11511454.filter(c,lv)
	return c:IsSetCard(0xffb) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:GetLevel()==lv
end
function c11511454.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511454.filter,tp,LOCATION_DECK,0,1,nil,9)
		or Duel.IsExistingMatchingCard(c11511454.filter,tp,LOCATION_DECK,0,2,nil,4) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11511454.op1(e,tp,eg,ep,ev,re,r,rp)
	local b1= Duel.IsExistingMatchingCard(c11511454.filter,tp,LOCATION_DECK,0,1,nil,9)
	local b2= Duel.IsExistingMatchingCard(c11511454.filter,tp,LOCATION_DECK,0,2,nil,4)
	local op
	local g
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(11511454,0),aux.Stringid(11511454,1))
	elseif b1 then op=0
	elseif b2 then op=1
	else return 
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if op==0 then
		g=Duel.SelectMatchingCard(tp,c11511454.filter,tp,LOCATION_DECK,0,1,1,nil,9)
	else
		g=Duel.SelectMatchingCard(tp,c11511454.filter,tp,LOCATION_DECK,0,2,2,nil,4)
	end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11511454.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11511454.filte2(c)
	return c:IsSetCard(0xffb) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c11511454.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511454.filte2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c11511454.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11511454.filte2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end