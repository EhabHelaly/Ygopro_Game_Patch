--Bi-Horned Dragon
function c11511105.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--sp limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11511105.splimit)
	e2:SetCondition(c11511105.splimcon)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c11511105.ttarget)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
    --indest effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c11511105.ttarget)
	e4:SetValue(c11511105.indval)
	c:RegisterEffect(e4)
	--Tri to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11511105,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1)
	e5:SetCondition(c11511105.hcon)
	e5:SetTarget(c11511105.htg)
	e5:SetOperation(c11511105.hop)
	c:RegisterEffect(e5)
    --atk
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c11511105.valatk)
	c:RegisterEffect(e6)
	--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(11511105,0))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,11511105)
	e7:SetTarget(c11511105.target)
	e7:SetOperation(c11511105.operation)
	c:RegisterEffect(e7)
end
function c11511105.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xfe) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c11511105.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c11511105.ttarget(e,c)
	return c:IsCode(39111158) and c:IsFaceup()
end
function c11511105.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c11511105.hfilter(c)
	return c:IsSetCard(0x20fe) and c:IsFaceup()
end
function c11511105.hcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c11511105.hfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11511105.spfilter(c)
	return c:IsCode(39111158)  and c:IsAbleToHand()
end
function c11511105.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511105.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11511105.hop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11511105.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11511105.valfilter(c)
	return c:IsSetCard(0xfe) and c:IsFaceup()
end
function c11511105.valatk(e,c)
	return Duel.GetMatchingGroupCount(c11511105.valfilter,c:GetControler(),LOCATION_MZONE,0,nil)*100
end
function c11511105.filter(c)
	return c:IsSetCard(0x20fe) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11511105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511105.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11511105.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11511105.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
