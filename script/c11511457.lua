--SW Morale
function c11511457.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c11511457.spcon)
	e2:SetTarget(c11511457.target)
	e2:SetOperation(c11511457.activate)
	c:RegisterEffect(e2)
	--battle
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c11511457.btcon)
	e3:SetTarget(c11511457.target)
	e3:SetOperation(c11511457.activate)
	c:RegisterEffect(e3)
end
function c11511457.spfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0xffb) and c:IsPreviousLocation(LOCATION_HAND)
end
function c11511457.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11511457.spfilter,1,nil,tp)
end
function c11511457.btcon(e,tp,eg,ep,ev,re,r,rp)
	local c1=Duel.GetAttacker()
	local c2=Duel.GetAttackTarget()
	if c1:GetControler()==1-tp then c1=c2 c2=Duel.GetAttacker() end

	return c1 and c2 and c1:IsSetCard(0xffb) and not c1:IsReason(REASON_BATTLE) and c2:IsReason(REASON_BATTLE) and eg:IsContains(c1)
end
function c11511457.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xffb)
end
function c11511457.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11511457.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c11511457.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11511457.filter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	local turns 
	if Duel.GetTurnPlayer()==tp then turns=2 else turns=1 end

	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,turns)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
