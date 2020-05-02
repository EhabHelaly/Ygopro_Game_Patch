-- Kairem Zone
function c11511314.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--reduce tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xffc))
	e2:SetValue(0x20002)
	c:RegisterEffect(e2)
	-- add to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c11511314.con)
	e3:SetCountLimit(1,11511313)
	e3:SetTarget(c11511314.tg)
	e3:SetOperation(c11511314.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	c:RegisterEffect(e4)
end
function c11511314.filterDes(c,tp)
	return c:IsSetCard(0xffc) and c:IsControler(tp) and c:GetPreviousControler()==tp and c:GetPreviousLocation()==LOCATION_MZONE
end
function c11511314.con(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c11511314.filterDes,nil,tp)
	if g:GetCount()==1 then e:SetLabel(g:GetFirst():GetLevel()) end
	return g:GetCount()==1
end
function c11511314.filterDeck(c,lv)
	return c:IsSetCard(0xffc) and c:IsAbleToHand() and c:GetLevel()==lv and c:IsType(TYPE_MONSTER)
end
function c11511314.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511314.filterDeck,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end

	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11511314.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11511314.filterDeck,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
