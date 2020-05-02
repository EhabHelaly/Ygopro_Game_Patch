-- Kairem Zeta
function c11511313.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xffc),6,2)
	c:EnableReviveLimit()

	-- attack twice (Xyz Summon)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11511313.conSP)
	e1:SetCost(c11511313.cost1)
	e1:SetCountLimit(1)
	e1:SetOperation(c11511313.op1)
	e1:SetLabel(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	-- Change Scale (Xyz Summon)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11511313.conSP)
	e2:SetTarget(c11511313.tg2)
	e2:SetOperation(c11511313.op2)
	e2:SetLabel(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	-- atk increase (Pendulum Summon)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c11511313.conSP)
	e3:SetOperation(c11511313.op3)
	e3:SetLabel(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e3)
	-- Destroy (Pendulum effect)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c11511313.tg4)
	e4:SetOperation(c11511313.op4)
	c:RegisterEffect(e4)
end
c11511313.pendulum_level=8

function c11511313.conSP(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==e:GetLabel()
end
function c11511313.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11511313.op1(e,tp,eg,ep,ev,re,r,rp)
	-- attack twice
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c11511313.filter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xffc)
end
function c11511313.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511313.filter2,tp,LOCATION_PZONE,0,1,nil) end
end
function c11511313.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11511313.filter2,tp,LOCATION_PZONE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local value=1
		if tc:GetLeftScale()>0 and tc:GetRightScale()>0 then
			value=Duel.SelectOption(tp,aux.Stringid(11511313,0),aux.Stringid(11511313,1))*-2+1
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(value)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
	end
end

function c11511313.filter3(c)
	return c:IsSetCard(0xffc) and c:IsFaceup()
end
function c11511313.op3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11511313.filter3,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end

	local sc=g:GetFirst()
	local c=e:GetHandler()
	while sc do
		-- atk increase	
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		sc:RegisterEffect(e1)
		sc=g:GetNext()
	end
end

function c11511313.filter4(c)
	return c:IsSetCard(0xffc) and c:IsDestructable()
end
function c11511313.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511313.filter4,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,2,0,0)
end
function c11511313.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11511313.filter4,tp,LOCATION_MZONE,0,1,1,nil) 
	if g:GetCount() and Duel.Destroy(g,REASON_EFFECT) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g2:GetCount() then 
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end
