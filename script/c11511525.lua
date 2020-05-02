--Vortex Tempo
function c11511525.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11511514,aux.FilterBoolFunction(c11511525.filterF),1,true)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c11511525.con)
	e1:SetTarget(c11511525.tg)
	e1:SetOperation(c11511525.op)
	c:RegisterEffect(e1)
end
function c11511525.filterF(c)
	return c:IsFusionSetCard(0xffa) and c:IsFusionAttribute(ATTRIBUTE_WIND)
end
function c11511525.filterR(c,race)
	return c:IsRace(race) and c:IsFaceup()
end
function c11511525.filter(c,tp)
	return c:IsSetCard(0xffa) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
	and not Duel.IsExistingMatchingCard(c11511525.filterR,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c,c:GetRace()) 
end
function c11511525.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11511525.filter,tp,nil,tp)
end
function c11511525.filterDes(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c11511525.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511525.filterDes,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11511525.filterDes,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),nil,LOCATION_ONFIELD)
end
function c11511525.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
